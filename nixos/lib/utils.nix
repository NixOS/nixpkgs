{
  lib,
  config,
  pkgs,
}:

let

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
    fsNeededForBoot = fs: fs.neededForBoot || lib.elem fs.mountPoint pathsNeededForBoot;

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
        normalisePath = path: "${path}${lib.optionalString (!(lib.hasSuffix "/" path)) "/"}";
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
      lib.hasPrefix a'.mountPoint b'.device
      || lib.hasPrefix a'.mountPoint b'.mountPoint
      || lib.any (lib.hasPrefix a'.mountPoint) b'.depends;

    # Escape a path according to the systemd rules. FIXME: slow
    # The rules are described in systemd.unit(5) as follows:
    # The escaping algorithm operates as follows: given a string, any "/" character is replaced by "-", and all other characters which are not ASCII alphanumerics, ":", "_" or "." are replaced by C-style "\x2d" escapes. In addition, "." is replaced with such a C-style escape when it would appear as the first character in the escaped string.
    # When the input qualifies as absolute file system path, this algorithm is extended slightly: the path to the root directory "/" is encoded as single dash "-". In addition, any leading, trailing or duplicate "/" characters are removed from the string before transformation. Example: /foo//bar/baz/ becomes "foo-bar-baz".
    escapeSystemdPath =
      s:
      let
        replacePrefix =
          p: r: s:
          (if (lib.hasPrefix p s) then r + (lib.removePrefix p s) else s);
        trim = s: lib.removeSuffix "/" (lib.removePrefix "/" s);
        normalizedPath = normalizePath s;
      in
      lib.replaceStrings [ "/" ] [ "-" ] (
        replacePrefix "." (escapeC [ "." ] ".") (
          escapeC (lib.stringToCharacters " !\"#$%&'()*+,;<=>=@[\\]^`{|}~-") (
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
          if lib.isPath arg then
            "${arg}"
          else if lib.isString arg then
            arg
          else if lib.isInt arg || lib.isFloat arg || lib.isDerivation arg then
            toString arg
          else
            throw "escapeSystemdExecArg only allows strings, paths, numbers and derivations";
      in
      lib.replaceStrings [ "%" "$" ] [ "%%" "$$" ] (toJSON s);

    # Quotes a list of arguments into a single string for use in a Exec*
    # line.
    escapeSystemdExecArgs = lib.concatMapStringsSep " " escapeSystemdExecArg;

    # Returns a system path for a given shell package
    toShellPath =
      shell:
      if lib.types.shellPackage.check shell then
        "/run/current-system/sw${shell.shellPath}"
      else if lib.types.package.check shell then
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
      item: attr: lib.mapAttrs (_name: set: set.${attr}) (recursiveGetAttrsetWithJqPrefix item attr);

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
            lib.nameValuePair prefix item
          else if lib.isDerivation item then
            [ ]
          else if lib.isAttrs item then
            map (
              name:
              let
                escapedName = ''"${lib.replaceStrings [ ''"'' "\\" ] [ ''\"'' "\\\\" ] name}"'';
              in
              recurse (prefix + "." + escapedName) item.${name}
            ) (lib.attrNames item)
          else if lib.isList item then
            lib.imap0 (index: item: recurse (prefix + "[${toString index}]") item) item
          else
            [ ];
      in
      lib.listToAttrs (lib.flatten (recurse "" item));

    /*
      Takes an attrset and a file path and generates a bash snippet that
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
    genJqSecretsReplacementSnippet' =
      attr: set: output:
      let
        secretsRaw = recursiveGetAttrsetWithJqPrefix set attr;
        # Set default option values
        secrets = lib.mapAttrs (
          _name: set:
          {
            quote = true;
          }
          // set
        ) secretsRaw;
        stringOrDefault = str: def: if str == "" then def else str;
      in
      ''
        if [[ -h '${output}' ]]; then
          rm '${output}'
        fi

        inherit_errexit_enabled=0
        shopt -pq inherit_errexit && inherit_errexit_enabled=1
        shopt -s inherit_errexit
      ''
      + lib.concatStringsSep "\n" (
        lib.imap1 (index: name: ''
          secret${toString index}=$(<'${secrets.${name}.${attr}}')
          export secret${toString index}
        '') (lib.attrNames secrets)
      )
      + "\n"
      + "${pkgs.jq}/bin/jq >'${output}' "
      + lib.escapeShellArg (
        stringOrDefault (lib.concatStringsSep " | " (
          lib.imap1 (
            index: name:
            ''${name} = ($ENV.secret${toString index}${lib.optionalString (!secrets.${name}.quote) " | fromjson"})''
          ) (lib.attrNames secrets)
        )) "."
      )
      + ''
         <<'EOF'
        ${toJSON set}
        EOF
        (( ! $inherit_errexit_enabled )) && shopt -u inherit_errexit
      '';

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
        namesToRemove = map lib.getName packagesToRemove;
      in
      lib.filter (x: !(lib.elem (lib.getName x) namesToRemove)) packages;

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
        namesToDisable = map lib.getName packagesToDisable;
      in
      !lib.elem (lib.getName package) namesToDisable;

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
