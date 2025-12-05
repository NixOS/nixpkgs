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
    escapeShellArg
    filter
    flatten
    getName
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
        } "_secret" -> { ".example[1].relevant.secret" = { _secret = "/path/to/secret"; quote = true; }; }
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
            imap0 (index: item: recurse (prefix + "[${toString index}]") item) item
          else
            [ ];
      in
      listToAttrs (flatten (recurse "." item));

    /*
      Takes some options, an attrset and a file path and generates a bash snippet that
      outputs a JSON file at the file path with all instances of

      { _secret = "/path/to/secret" }

      in the attrset replaced with the contents of the file
      "/path/to/secret" in the output JSON.

      The first argument exposes the following options:

      - attr: The name of the secret attribute that will be processed, defaults to "_secret"
      - loadCredential: A boolean determining whether the script should load secrets directly (false)
        or load them from $CREDENTIALS_DIRECTORY (true). In the latter case the output attribute set
        will contain a .credentials attribute with the necessary credential list that can be passed
        to systemd's `LoadCredential=` option.

      The output of this utility is an attribute set containing the main script and optionally
      a list of credentials:

      {
        # The main script
        script = "...";

        # If the loadCredential option was set:
        credentials = [
          "secret1:/path/to/secret1"
          #...
        ];
      }

      When a configuration option accepts an attrset that is finally
      converted to JSON, this makes it possible to let the user define
      arbitrary secret values.

      Example:
        If the file "/path/to/secret" contains the string
        "topsecretpassword1234",

        genJqSecretsReplacement { } {
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

        genJqSecretsReplacement { } {
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
    genJqSecretsReplacement =
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
        stringOrDefault = str: def: if str == "" then def else str;

        # Sanitize path to create a valid credential tag (same as in genLoadCredentialForJqSecretsReplacementSnippet)
        sanitizePath =
          path: lib.stringAsChars (c: if builtins.match "[a-zA-Z0-9_.#=!-]" c != null then c else "_") path;

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

          inherit_errexit_enabled=0
          shopt -pq inherit_errexit && inherit_errexit_enabled=1
          shopt -s inherit_errexit
        ''
        + concatStringsSep "\n" (
          imap1 (
            index: name:
            # We keep variable assignment and export separated to avoid masking the return code of the file access.
            # With `set -e` this will now fail if a file doesn't exist.
            ''
              secret${toString index}=$(<${credentialPath index name})
              export secret${toString index}
            '') (attrNames secrets)
        )
        + "\n"
        + "${pkgs.jq}/bin/jq >'${output}' "
        + escapeShellArg (
          stringOrDefault (concatStringsSep " | " (
            imap1 (
              index: name:
              ''${name} = ($ENV.secret${toString index}${optionalString (!secrets.${name}.quote) " | fromjson"})''
            ) (attrNames secrets)
          )) "."
        )
        + ''
           <<'EOF'
          ${toJSON set}
          EOF
          (( ! inherit_errexit_enabled )) && shopt -u inherit_errexit
        '';

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
  };
in
utils
