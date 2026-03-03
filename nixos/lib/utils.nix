{
  lib,
  config,
  pkgs,
}:

let
  inherit (lib)
    any
    attrNames
    concatMapStringsSep
    concatStringsSep
    elem
    filter
    flatten
    getName
    hasAttr
    hasPrefix
    hasSuffix
    imap0
    imap1
    isAttrs
    isDerivation
    isFloat
    isInt
    isList
    isPath
    isString
    listToAttrs
    mapAttrs
    nameValuePair
    optionalString
    removePrefix
    removeSuffix
    replaceStrings
    stringToCharacters
    types
    ;

  inherit (lib.strings) toJSON normalizePath escapeC;
in

let
  utils = rec {

    # Copy configuration files to avoid having the entire sources in the system closure
    copyFile =
      filePath:
      pkgs.runCommand (builtins.unsafeDiscardStringContext (baseNameOf filePath)) { } ''
        cp ${filePath} $out
      '';

    # Check whenever fileSystem is needed for boot.  NOTE: Make sure
    # pathsNeededForBoot is closed under the parent relationship, i.e. if /a/b/c
    # is in the list, put /a and /a/b in as well.
    pathsNeededForBoot = [
      "/"
      "/nix"
      "/nix/store"
      "/var"
      "/var/log"
      "/var/lib"
      "/var/lib/nixos"
      "/etc"
      "/usr"
    ];
    fsNeededForBoot = fs: fs.neededForBoot || elem fs.mountPoint pathsNeededForBoot;

    # Check whenever `b` depends on `a` as a fileSystem
    fsBefore =
      a: b:
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
        normalise =
          mount:
          mount
          // {
            device = normalisePath (toString mount.device);
            mountPoint = normalisePath mount.mountPoint;
            depends = map normalisePath mount.depends;
          };

        a' = normalise a;
        b' = normalise b;

      in
      hasPrefix a'.mountPoint b'.device
      || hasPrefix a'.mountPoint b'.mountPoint
      || any (hasPrefix a'.mountPoint) b'.depends;

    # Escape a path according to the systemd rules. FIXME: slow
    # The rules are described in systemd.unit(5) as follows:
    # The escaping algorithm operates as follows: given a string, any "/" character is replaced by "-", and all other characters which are not ASCII alphanumerics, ":", "_" or "." are replaced by C-style "\x2d" escapes. In addition, "." is replaced with such a C-style escape when it would appear as the first character in the escaped string.
    # When the input qualifies as absolute file system path, this algorithm is extended slightly: the path to the root directory "/" is encoded as single dash "-". In addition, any leading, trailing or duplicate "/" characters are removed from the string before transformation. Example: /foo//bar/baz/ becomes "foo-bar-baz".
    escapeSystemdPath =
      s:
      let
        replacePrefix =
          p: r: s:
          (if (hasPrefix p s) then r + (removePrefix p s) else s);
        trim = s: removeSuffix "/" (removePrefix "/" s);
        normalizedPath = normalizePath s;
      in
      replaceStrings [ "/" ] [ "-" ] (
        replacePrefix "." (escapeC [ "." ] ".") (
          escapeC (stringToCharacters " !\"#$%&'()*+,;<=>=@[\\]^`{|}~-") (
            if normalizedPath == "/" then normalizedPath else trim normalizedPath
          )
        )
      );

    # Quotes an argument for use in Exec* service lines.
    # systemd accepts "-quoted strings with escape sequences, toJSON produces
    # a subset of these.
    # Additionally we escape % to disallow expansion of % specifiers. Any lone ;
    # in the input will be turned it ";" and thus lose its special meaning.
    # Every $ is escaped to $$, this makes it unnecessary to disable environment
    # substitution for the directive.
    escapeSystemdExecArg =
      arg:
      let
        s =
          if isPath arg then
            "${arg}"
          else if isString arg then
            arg
          else if isInt arg || isFloat arg || isDerivation arg then
            toString arg
          else
            throw "escapeSystemdExecArg only allows strings, paths, numbers and derivations";
      in
      replaceStrings [ "%" "$" ] [ "%%" "$$" ] (toJSON s);

    # Quotes a list of arguments into a single string for use in a Exec*
    # line.
    escapeSystemdExecArgs = concatMapStringsSep " " escapeSystemdExecArg;

    # Returns a system path for a given shell package
    toShellPath =
      shell:
      if types.shellPackage.check shell then
        "/run/current-system/sw${shell.shellPath}"
      else if types.package.check shell then
        throw "${shell} is not a shell package"
      else
        shell;

    /*
      Recurse into a list or an attrset, searching for attrs named like
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
    recursiveGetAttrWithJqPrefix =
      item: attr: mapAttrs (_name: set: set.${attr}) (recursiveGetAttrsetWithJqPrefix item attr);

    /*
      Similar to `recursiveGetAttrWithJqPrefix`, but returns the whole
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
        } "_secret" -> { ".example.1.relevant.secret" = { _secret = "/path/to/secret"; quote = true; }; }
    */
    recursiveGetAttrsetWithJqPrefix =
      item: attr:
      let
        recurse =
          prefix: item:
          if item ? ${attr} then
            nameValuePair prefix item
          else if isDerivation item then
            [ ]
          else if isAttrs item then
            map (
              name:
              let
                escapedName = ''"${replaceStrings [ ''"'' "\\" ] [ ''\"'' "\\\\" ] name}"'';
              in
              recurse (prefix + (if prefix == "." then "" else ".") + escapedName) item.${name}
            ) (attrNames item)
          else if isList item then
            imap0 (index: item: recurse (prefix + ''."${toString index}"'') item) item
          else
            [ ];
      in
      listToAttrs (flatten (recurse "." item));

    /*
      Takes some options, an attrset and a file path and generates a bash snippet that
      outputs a JSON file at the file path with all instances of

      ```nix
      { _secret = "/path/to/secret" }
      ```

      in the attrset replaced with the contents of the file `/path/to/secret`.

      This function uses `genSecretsReplacement` under the hood with its first input value
      set to generate JSON configurations files. See the documentation for that function
      for examples, implementation details and documentation about all inputs.
    */
    genJqSecretsReplacement = genSecretsReplacement {
      generator = toJSON;
      escape_style = "json";
    };

    /*
      Used to generate a configuration file which contains secrets
      whithout storing the secrets in the nix store.

      :::{.info}
      This function expects the secrets to be readily available on the target host
      at pre-established locations. An out of band tool is required to transport the secrets.

      Further documentation can be found [in the nixpkgs manual](https://nixos.org/nixpkgs/manual/index.html#sec-secrets).
      :::

      Takes a config file generator, some options for fine tuning,
      the config file expressed in nix - an arbitrary value of nested lists and attrsets -
      and a file path where the config file will be created on the target host.

      This function will store in the nix store a version of the given config file
      with secrets replaced by uniquely identifiable placeholders.
      It then generates a bash snippet that takes the config file in the nix store
      and creates the config file in the wanted location with all placeholders
      replaced with the decrypted secrets.

      By default, this function assumes the user running the bash script can access
      all files containing the required secrets. If that's not the case, the `loadCredential` attribute
      can be set to `true` to make use of
      [systemd's `LoadCredential` feature](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html?#LoadCredential=ID:PATH)
      that bypasses this permission issue.

      # Inputs

      `generator`

      : 1\. Generator attrset with two attrs:
        - `generator`: `a -> String` the function generating the config file.
          It takes one argument, an arbitrary value of nested lists and attrsets
          and produces a string which is the config file itself in the expected format (json, yaml, etc.).
        - `escape_style`: a string which currently can only be `json` which describes
          how the decrypted secret should be sanitized to be embedded into the config file.
          For example, this tells to escape the quote `"` character by adding a backslash when
          replacing a placeholder in a JSON string with a secret containing a quote.
          Secrets that should not be quoted (with `quote = false`) will not be escaped.

      `options`

      : 2\. Options on how to parse the configuration file
        - attr: The name of the attribute that will be identify a value as identifying a secret, defaults to `_secret`.
        - loadCredential: A boolean determining whether the script should load secrets directly (false)
          or load them from $CREDENTIALS_DIRECTORY (true), defaults to `false`. In the latter case the output attribute set
          will contain a `.credentials` attr with the necessary credential list that can be passed
          to systemd's `LoadCredential=` option.

      `configuration`

      : 3\. Arbitrary value of nested attrset or list. The `generator` function will be applied to it
        after all secrets - the attrsets containing the `attr` attribute (which is `_secret` by default) -
        are replaced by uniquely identified placeholders. The output of the `generator` function is
        then stored in the nix store.

        Additional attributes can be added next to `attr` to further customize
        how the secret whould be embedded:

        - `quote`: If `quote = true`, the default, the content of the secret file will
          be quoted and embedded following the `escape_style`.

          Otherwise, if `quote = false`, the content of the secret file will be outputted as-is,
          without quotes.Care should then be taken to make sure the format is compatible with the
          one from generator. This allows for structured secrets.

      `path`

      : A `string` representing the path where the configuration will be created on the target host.

      # Output

      `output`

      : Attrset containing:
        - `script`: The bash script that creates the final configuration with embedded secrets in the expected location
          by replacing all placeholders with the secrets in the configuration file stored in the nix store.
        - `credentials`: The credential list to give to systemd's `LoadCredential=`. Only available when the
          `loadCredential` attribute is set to `true` in the `options` attrset.

      # Type

      ```
      genSecretsReplacement :: Attrset -> Attrset -> a -> String -> Attrset
      ```

      # Example - JSON Generation

      Assuming the file `/path/to/secret` exists and contains `topsecretpassword1234`,
      the following function call:

      ```nix
      genSecretsReplacement { escape_style = "json"; generator = builtins.toJSON; } { } {
        example = [
          {
            not_a_secret = "some value";
          }
          {
            not_a_secret = "some value";
            relevant = {
              secret = {
                _secret = "/path/to/secret";
              };
            };
          }
        ];
      } "/path/to/output.json"
      ```

      would generate a snippet that, when run, outputs the following file at "/path/to/output.json":

      ```json
      {
        "example": [
          {
            not_a_secret = "some value";
          },
          {
            not_a_secret = "some value";
            "relevant": {
              "secret": "topsecretpassword1234"
            }
          }
        ]
      }
      ```

      # Example - Structured Secret

      The attribute set `{ _secret = "/path/to/secret"; }` can contain extra
      options, currently it accepts the `quote = true|false` option.

      Assuming the file `/path/to/secret` exists and contains an actual JSON valid value:

      ```json
      [
        { "a": "topsecretpassword1234" },
        { "b": "topsecretpassword5678" }
      ]
      ```

      the following function call:

      ```nix
      genSecretsReplacement { escape_style = "json"; generator = builtins.toJSON; } { } {
        example = [
          {
            not_a_secret = "some value";
          }
          {
            not_a_secret = "some value";
            relevant = {
              secret = {
                _secret = "/path/to/secret";
              };
            };
          }
        ];
      } "/path/to/output.json"
      ```

      would generate a snippet that, when run, outputs the following file at "/path/to/output.json":

      ```json
      {
        "example": [
          {
            not_a_secret = "some value";
          },
          {
            not_a_secret = "some value";
            "relevant": {
              "secret": [
                { "a": "topsecretpassword1234" },
                { "b": "topsecretpassword5678" }
              ]
            }
          }
        ]
      }
      ```
    */
    genSecretsReplacement =
      { generator, escape_style }:
      {
        attr ? "_secret",
        loadCredential ? false,
      }:
      set: output:
      let
        secretsRaw = recursiveGetAttrsetWithJqPrefix set attr;
        # Set default option values
        secrets = mapAttrs (
          _name: set:
          {
            quote = true;
          }
          // set
        ) secretsRaw;

        # Like `mapAttrsRecursiveCond` but also recurses over lists.
        mapAttrsRecursiveCond' =
          cond: f: set:
          let
            recurse =
              path: val:
              if isAttrs val && cond val then
                mapAttrs (n: v: recurse (path ++ [ n ]) v) val
              else if isList val && cond val then
                imap0 (i: v: recurse (path ++ [ (toString i) ]) v) val
              else
                f path val;
          in
          recurse [ ] set;

        # Change the _secret values inside the set by the path
        setWithSecretsReplaced = mapAttrsRecursiveCond' (as: !(isAttrs as && hasAttr attr as)) (
          path: item:
          if (isAttrs item && hasAttr attr item) then
            sanitizePath "@.${concatMapStringsSep "." (n: lib.escape ''"${n}"'') path}@"
          else
            item
        ) set;

        # Sanitize path to create a valid credential tag (same as in genLoadCredentialForJqSecretsReplacementSnippet)
        sanitizePath =
          path: lib.stringAsChars (c: if builtins.match "[a-zA-Z0-9_.#=!-]" c != null then c else "") path;

        # Generate credential tag for a given index and path
        credentialTag = index: path: "${toString index}_${sanitizePath (secrets.${path}.${attr})}";

        credentialPath =
          index: name:
          if loadCredential then
            ''"$CREDENTIALS_DIRECTORY/${credentialTag index name}"''
          else
            "'${secrets.${name}.${attr}}'";
      in
      {
        script = ''
          if [[ -h '${output}' ]]; then
            rm '${output}'
          fi

          cat >'${output}' <<'EOF'
          ${generator setWithSecretsReplaced}
          EOF
        ''
        + (concatStringsSep "\n" (
          imap1 (index: name: ''
            ${pkgs.replace-secret}/bin/replace-secret "\"${sanitizePath "@${name}@"}\"" ${credentialPath index name} '${output}' ${
              optionalString secrets.${name}.quote "--escape --escape_style=${escape_style}"
            }
          '') (attrNames secrets)
        ));

        /*
          Generates a list of systemd LoadCredential entries if loadCredential was set,
          otherwise returns null.

          The tag is sanitized to only contain characters a-zA-Z0-9_-.#=! and prefixed
          with an index to ensure uniqueness.

          Example:
            genLoadCredentialForJqSecretsReplacementSnippet { } {
              example = {
                secret1 = { _secret = "/path/to/secret"; };
                secret2 = { _secret = "/another/secret"; };
              };
            }
            -> [ "0_path_to_secret:/path/to/secret" "1_another_secret:/another/secret" ]
        */
        credentials =
          if loadCredential then
            imap1 (
              index: path:
              "${toString index}_${sanitizePath (secretsRaw.${path}.${attr})}:${secretsRaw.${path}.${attr}}"
            ) (attrNames secretsRaw)
          else
            null;
      };

    /*
      A convenience function around `genJqSecretsReplacement` without any additional
      settings that returns just the script that does the secret replacing. Make sure
      to have a look at `genJqSecretsReplacement` first to decide whether you need
      the additional functionality.

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

        will return a set of bash commands that replaces the secret values
        in the given attrset with values from the respective files and saves the result
        as a JSON file.
    */
    genJqSecretsReplacementSnippet = set: output: (genJqSecretsReplacement { } set output).script;

    /*
      Remove packages of packagesToRemove from packages, based on their names.
      Relies on package names and has quadratic complexity so use with caution!

      Type:
        removePackagesByName :: [package] -> [package] -> [package]

      Example:
        removePackagesByName [ nautilus file-roller ] [ file-roller totem ]
        => [ nautilus ]
    */
    removePackagesByName =
      packages: packagesToRemove:
      let
        namesToRemove = map getName packagesToRemove;
      in
      filter (x: !(elem (getName x) namesToRemove)) packages;

    /*
      Returns false if a package with the same name as the `package` is present in `packagesToDisable`.

      Type:
        disablePackageByName :: package -> [package] -> bool

      Example:
        disablePackageByName file-roller [ file-roller totem ]
        => false

      Example:
        disablePackageByName nautilus [ file-roller totem ]
        => true
    */
    disablePackageByName =
      package: packagesToDisable:
      let
        namesToDisable = map getName packagesToDisable;
      in
      !elem (getName package) namesToDisable;

    systemdUtils = {
      lib = import ./systemd-lib.nix {
        inherit
          lib
          config
          pkgs
          utils
          ;
      };
      unitOptions = import ./systemd-unit-options.nix { inherit lib systemdUtils; };
      types = import ./systemd-types.nix { inherit lib systemdUtils pkgs; };
      network = {
        units = import ./systemd-network-units.nix { inherit lib systemdUtils; };
      };
    };

    /*
      Mapping of systems to “magicOrExtension” and “mask”. Mostly taken from:
      - https://github.com/cleverca22/nixos-configs/blob/master/qemu.nix
      and
      - https://github.com/qemu/qemu/blob/master/scripts/qemu-binfmt-conf.sh
    */
    binfmtMagics = import ./binfmt-magics.nix;
  };
in
utils
