{ lib, config, pkgs }:

let
  inherit (lib)
    any
    attrNames
    concatMapStringsSep
    concatStringsSep
    elem
    filter
    flatten
    getExe
    getName
    getPlaceholderReplacements
    getLoadCredentials
    hasPrefix
    hasSuffix
    imap0
    isAttrs
    isDerivation
    isFloat
    isInt
    isList
    isPath
    isString
    listToAttrs
    mapAttrs
    mapAttrsToList
    nameValuePair
    optionalString
    removePrefix
    removeSuffix
    replaceWithPlaceholder
    replaceStrings
    stringToCharacters
    types
    updateToLoadCredentials
    ;

  inherit (lib.strings) toJSON normalizePath escapeC;
in

let
utils = rec {

  # Copy configuration files to avoid having the entire sources in the system closure
  copyFile = filePath: pkgs.runCommand (builtins.unsafeDiscardStringContext (baseNameOf filePath)) {} ''
    cp ${filePath} $out
  '';

  # Check whenever fileSystem is needed for boot.  NOTE: Make sure
  # pathsNeededForBoot is closed under the parent relationship, i.e. if /a/b/c
  # is in the list, put /a and /a/b in as well.
  pathsNeededForBoot = [ "/" "/nix" "/nix/store" "/var" "/var/log" "/var/lib" "/var/lib/nixos" "/etc" "/usr" ];
  fsNeededForBoot = fs: fs.neededForBoot || elem fs.mountPoint pathsNeededForBoot;

  # Check whenever `b` depends on `a` as a fileSystem
  fsBefore = a: b:
    let
      # normalisePath adds a slash at the end of the path if it didn't already
      # have one.
      #
      # The reason slashes are added at the end of each path is to prevent `b`
      # from accidentally depending on `a` in cases like
      #    a = { mountPoint = "/aaa"; ... }
      #    b = { device     = "/aaaa"; ... }
      # Here a.mountPoint *is* a prefix of b.device even though a.mountPoint is
      # *not* a parent of b.device. If we add a slash at the end of each string,
      # though, this is not a problem: "/aaa/" is not a prefix of "/aaaa/".
      normalisePath = path: "${path}${optionalString (!(hasSuffix "/" path)) "/"}";
      normalise = mount: mount // { device = normalisePath (toString mount.device);
                                    mountPoint = normalisePath mount.mountPoint;
                                    depends = map normalisePath mount.depends;
                                  };

      a' = normalise a;
      b' = normalise b;

    in hasPrefix a'.mountPoint b'.device
    || hasPrefix a'.mountPoint b'.mountPoint
    || any (hasPrefix a'.mountPoint) b'.depends;

  # Escape a path according to the systemd rules. FIXME: slow
  # The rules are described in systemd.unit(5) as follows:
  # The escaping algorithm operates as follows: given a string, any "/" character is replaced by "-", and all other characters which are not ASCII alphanumerics, ":", "_" or "." are replaced by C-style "\x2d" escapes. In addition, "." is replaced with such a C-style escape when it would appear as the first character in the escaped string.
  # When the input qualifies as absolute file system path, this algorithm is extended slightly: the path to the root directory "/" is encoded as single dash "-". In addition, any leading, trailing or duplicate "/" characters are removed from the string before transformation. Example: /foo//bar/baz/ becomes "foo-bar-baz".
  escapeSystemdPath = s: let
    replacePrefix = p: r: s: (if (hasPrefix p s) then r + (removePrefix p s) else s);
    trim = s: removeSuffix "/" (removePrefix "/" s);
    normalizedPath = normalizePath s;
  in
    replaceStrings ["/"] ["-"]
    (replacePrefix "." (escapeC ["."] ".")
    (escapeC (stringToCharacters " !\"#$%&'()*+,;<=>=@[\\]^`{|}~-")
    (if normalizedPath == "/" then normalizedPath else trim normalizedPath)));

  # Quotes an argument for use in Exec* service lines.
  # systemd accepts "-quoted strings with escape sequences, toJSON produces
  # a subset of these.
  # Additionally we escape % to disallow expansion of % specifiers. Any lone ;
  # in the input will be turned it ";" and thus lose its special meaning.
  # Every $ is escaped to $$, this makes it unnecessary to disable environment
  # substitution for the directive.
  escapeSystemdExecArg = arg:
    let
      s = if isPath arg then "${arg}"
        else if isString arg then arg
        else if isInt arg || isFloat arg || isDerivation arg then toString arg
        else throw "escapeSystemdExecArg only allows strings, paths, numbers and derivations";
    in
      replaceStrings [ "%" "$" ] [ "%%" "$$" ] (toJSON s);

  # Quotes a list of arguments into a single string for use in a Exec*
  # line.
  escapeSystemdExecArgs = concatMapStringsSep " " escapeSystemdExecArg;

  # Returns a system path for a given shell package
  toShellPath = shell:
    if types.shellPackage.check shell then
      "/run/current-system/sw${shell.shellPath}"
    else if types.package.check shell then
      throw "${shell} is not a shell package"
    else
      shell;

  /* Recurse into a list or an attrset, searching for attrs named like
     the value of the "attr" parameter, and return an attrset where the
     names are the corresponding jq path where the attrs were found and
     the values are the values of the attrs.

     Example:
       recursiveGetAttrWithJqPrefix {
         example = [
           {
             irrelevant = "not interesting";
           }
           {
             ignored = "ignored attr";
             relevant = {
               secret = {
                 _secret = "/path/to/secret";
               };
             };
           }
         ];
       } "_secret" -> { ".example[1].relevant.secret" = "/path/to/secret"; }
  */
  recursiveGetAttrWithJqPrefix = item: attr: mapAttrs (_name: set: set.${attr}) (recursiveGetAttrsetWithJqPrefix item attr);

  /* Similar to `recursiveGetAttrWithJqPrefix`, but returns the whole
     attribute set containing `attr` instead of the value of `attr` in
     the set.

     Example:
       recursiveGetAttrsetWithJqPrefix {
         example = [
           {
             irrelevant = "not interesting";
           }
           {
             ignored = "ignored attr";
             relevant = {
               secret = {
                 _secret = "/path/to/secret";
                 quote = true;
               };
             };
           }
         ];
       } "_secret" -> { ".example[1].relevant.secret" = { _secret = "/path/to/secret"; quote = true; }; }
  */
  recursiveGetAttrsetWithJqPrefix = item: attr:
    let
      recurse = prefix: item:
        if item ? ${attr} then
          nameValuePair prefix item
        else if isDerivation item then []
        else if isAttrs item then
          map (name:
            let
              escapedName = ''"${replaceStrings [''"'' "\\"] [''\"'' "\\\\"] name}"'';
            in
              recurse (prefix + "." + escapedName) item.${name}) (attrNames item)
        else if isList item then
          imap0 (index: item: recurse (prefix + "[${toString index}]") item) item
        else
          [];
    in listToAttrs (flatten (recurse "" item));

  /* Takes an attrset and a file path and generates a bash snippet that
     outputs a JSON file at the file path with all instances of

     { _secret = "/path/to/secret" }

     in the attrset replaced with the contents of the file
     "/path/to/secret" in the output JSON.

     When a configuration option accepts an attrset that is finally
     converted to JSON, this makes it possible to let the user define
     arbitrary secret values.

     Example:
       If the file "/path/to/secret" contains the string
       "topsecretpassword1234",

       genJqSecretsReplacementSnippet {
         example = [
           {
             irrelevant = "not interesting";
           }
           {
             ignored = "ignored attr";
             relevant = {
               secret = {
                 _secret = "/path/to/secret";
               };
             };
           }
         ];
       } "/path/to/output.json"

       would generate a snippet that, when run, outputs the following
       JSON file at "/path/to/output.json":

       {
         "example": [
           {
             "irrelevant": "not interesting"
           },
           {
             "ignored": "ignored attr",
             "relevant": {
               "secret": "topsecretpassword1234"
             }
           }
         ]
       }

     The attribute set { _secret = "/path/to/secret"; } can contain extra
     options, currently it accepts the `quote = true|false` option.

     If `quote = true` (default behavior), the content of the secret file will
     be quoted as a string and embedded.  Otherwise, if `quote = false`, the
     content of the secret file will be parsed to JSON and then embedded.

     Example:
       If the file "/path/to/secret" contains the JSON document:

       [
         { "a": "topsecretpassword1234" },
         { "b": "topsecretpassword5678" }
       ]

       genJqSecretsReplacementSnippet {
         example = [
           {
             irrelevant = "not interesting";
           }
           {
             ignored = "ignored attr";
             relevant = {
               secret = {
                 _secret = "/path/to/secret";
                 quote = false;
               };
             };
           }
         ];
       } "/path/to/output.json"

       would generate a snippet that, when run, outputs the following
       JSON file at "/path/to/output.json":

       {
         "example": [
           {
             "irrelevant": "not interesting"
           },
           {
             "ignored": "ignored attr",
             "relevant": {
               "secret": [
                 { "a": "topsecretpassword1234" },
                 { "b": "topsecretpassword5678" }
               ]
             }
           }
         ]
       }
  */
  genJqSecretsReplacementSnippet = genJqSecretsReplacementSnippet' "_secret";

  # Like genJqSecretsReplacementSnippet, but allows the name of the
  # attr which identifies the secret to be changed.
  genJqSecretsReplacementSnippet' = attr: set: output:
    genConfigOutOfBand {
      config = set;
      configLocation = output;
      sourceField = attr;
      generator = utils.genConfigOutOfBandFormatAdapter (pkgs.formats.json {});
    };

  /* Remove packages of packagesToRemove from packages, based on their names.
     Relies on package names and has quadratic complexity so use with caution!

     Type:
       removePackagesByName :: [package] -> [package] -> [package]

     Example:
       removePackagesByName [ nautilus file-roller ] [ file-roller totem ]
       => [ nautilus ]
  */
  removePackagesByName = packages: packagesToRemove:
    let
      namesToRemove = map getName packagesToRemove;
    in
      filter (x: !(elem (getName x) namesToRemove)) packages;

  systemdUtils = {
    lib = import ./systemd-lib.nix { inherit lib config pkgs utils; };
    unitOptions = import ./systemd-unit-options.nix { inherit lib systemdUtils utils; };
    types = import ./systemd-types.nix { inherit lib systemdUtils pkgs; };
    network = {
      units = import ./systemd-network-units.nix { inherit lib systemdUtils; };
    };
  };

  /**
    Generate a configuration file from an attrset which can have some values coming out of band, replaced in the configuration file on the target system, usually in the `preStart` phase of a Systemd service or in the system activation script. This function returns the replacement script.


    # Inputs

    `config`

    : Any combination of AttrSet and List. By default, all values will be stored verbatim in the nix store.
    : For a value to be given out of band instead, the value must be replaced by an AttrSet with a `_secret` attribute. In this case, the `_secret` field must be a path to a file on the target filesystem that will contain the value to be inserted in the configuration file.
    : If given, the `prefix` field will be prefixed to the out of band value before being replaced in the configuration file.
    : If given, the `suffix` field will be suffixed to the out of band value before being replaced in the configuration file.

    `configLocation`

    : Location of the configuration file on the target filesystem, with all the values replaced.

    `generator`

    : Function to generate the configuration file from the first argument `config`.
    : The format can be anything like JSON, YAML, INI or others.
    : This function must create a file in the nix store and return the path to the file.
    : This generated file will not have secrets embedded yet.
    :
    : For convenience and maintainability, adapter functions are provided to accommodate two use cases.
    : When combining with a generator from `pkgs.formats`:

    ```nix
    genConfigOutOfBandFormatAdapter (pkgs.formats.yaml {});
    ```

    : When combining with a generator from `lib.generators`:

    ```nix
    genConfigOutOfBandGeneratorAdapter (lib.generators.toJSON {});
    ```

    `sourceField`

    : The name of field used to determine if a value is given out of band or not can be changed. By default, the field is `_secret`. Only change this default for backwards compatibility.

    # Type

    ```
    genConfigOutOfBand :: Any -> String -> (Any -> Path) -> Path
    ```

    # Examples
    :::{.example}
    ## `utils.genConfigOutOfBand` generating JSON file.

    ```nix
    aSecret = pkgs.writeText "a-secret.txt" "Secret of A";
    bSecret = pkgs.writeText "b-secret.txt" "Secret of B";

    config = {
      a.a._secret = aSecret;
      b = [{
        _secret = bSecret;
        prefix = "prefix-";
        suffix = "-suffix";
      }];
      c = "not secret C";
      d.d = "not secret D";
    };

    configLocation = "/var/lib/config.json";

    generator = replaceSecretsFormatAdapter (pkgs.formats.json {});

    systemd.service."myservice".preStart = genConfigOutOfBand {
      inherit config configLocation generator;
    };
    ```

    The resulting file will be:

    ```json
    {
      "a": { "a": "Secret of A" },
      "b": [ "prefix-Secret of B-suffix" ],
      "c": "not a secret",
      "d": { "d": "not a secret" }
    }
    ```
  */
  genConfigOutOfBand = { config, configLocation, generator, sourceField ? "_secret" }:
    let
      configWithPlaceholders = replaceWithPlaceholder sourceField config;

      fileWithPlaceholders = generator "template" configWithPlaceholders;

      replacements = getPlaceholderReplacements sourceField config;
    in
      replacePlaceholdersScript {
        inherit sourceField fileWithPlaceholders configLocation replacements;
      };

  genConfigOutOfBandSystemd = { config, configLocation, generator, sourceField ? "_secret" }:
    {
      loadCredentials = getLoadCredentials sourceField config;
      preStart = genConfigOutOfBand {
        inherit configLocation generator sourceField;
        config = updateToLoadCredentials sourceField "$CREDENTIALS_DIRECTORY" config;
      };
    };

  genConfigOutOfBandFormatAdapter = format:
    format.generate;

  genConfigOutOfBandGeneratorAdapter = generator: name: value:
    pkgs.writeText "generator-${name}" (generator value);

  replacePlaceholdersScript = { sourceField, fileWithPlaceholders, configLocation, replacements }:
    let
      replaceSecret = pattern: args:
        ''
          ${getExe pkgs.replace-secret} \
            ${pattern} "${args.${sourceField}}" "${configLocation}" \
            --prefix="${args.prefix}" \
            --suffix="${args.suffix}" \
            --prefix-if-not-present="${args.prefixIfNotPresent}" \
            --suffix-if-not-present="${args.suffixIfNotPresent}"
        '';
    in
      ''
      set -euo pipefail

      test -d "$(dirname "${configLocation}")" || mkdir -p "$(dirname "${configLocation}")"
      rm -f "${configLocation}"
      install -Dm600 "${fileWithPlaceholders}" "${configLocation}"
      ''
      + concatStringsSep "\n" (mapAttrsToList replaceSecret replacements);
};
in utils
