{
  lib,
  config,
  pkgs,
}:

let
  inherit (lib)
    all
    any
    attrNames
    concatImapStringsSep
    concatMapStringsSep
    concatStringsSep
    elem
    escapeShellArg
    filter
    flatten
    foldl'
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
    length
    listToAttrs
    literalMD
    mapAttrs
    mkOption
    nameValuePair
    optionalString
    removePrefix
    replaceStrings
    splitString
    stringToCharacters
    types
    versionOlder
    ;

  inherit (lib.lists) findFirstIndex;
  inherit (lib.strings) toJSON escapeC;
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

    # Escape a path according to the systemd rules.
    # The rules are described in systemd.unit(5) as follows:
    # The escaping algorithm operates as follows: given a string, any "/" character is replaced by "-", and all other characters which are not ASCII alphanumerics, ":", "_" or "." are replaced by C-style "\x2d" escapes. In addition, "." is replaced with such a C-style escape when it would appear as the first character in the escaped string.
    # When the input qualifies as absolute file system path, this algorithm is extended slightly: the path to the root directory "/" is encoded as single dash "-". In addition, any leading, trailing or duplicate "/" characters are removed from the string before transformation. Example: /foo//bar/baz/ becomes "foo-bar-baz".
    escapeSystemdPath =
      let
        # These don't depend on the path being escaped, so build them once
        # rather than on every call.
        escapeChar = escapeC (stringToCharacters " !\"#$%&'()*+,;<=>?@[\\]^`{|}~-");
        escapeLeadingDot = escapeC [ "." ] ".";
        slashesToDashes = replaceStrings [ "/" ] [ "-" ];
        replacePrefix =
          p: r: s:
          (if hasPrefix p s then r + removePrefix p s else s);
      in
      s:
      let
        isAbsolute = hasPrefix "/" s;
        # path_simplify(): collapse duplicate slashes and drop "." components.
        rawComponents = filter (c: c != "" && c != ".") (splitString "/" s);
        # systemd accepts ".." only where it is redundant: a leading ".." in an
        # absolute path refers to the root's parent, i.e. the root itself, and is
        # dropped. Any other ".." cannot be resolved without the filesystem, so
        # the path is not normalized and systemd-escape errors on it.
        simplified =
          foldl'
            (
              acc: c:
              if c == ".." then
                # A leading ".." in an absolute path is the only redundant case.
                if isAbsolute && acc.components == [ ] then acc else acc // { normalized = false; }
              else
                acc // { components = acc.components ++ [ c ]; }
            )
            {
              components = [ ];
              normalized = true;
            }
            rawComponents;
        notNormalized = throw "escapeSystemdPath: ${s} is not a normalized path";
        simplifiedPath =
          if !simplified.normalized then
            notNormalized
          else if simplified.components != [ ] then
            concatStringsSep "/" simplified.components
          # The root directory, and - matching systemd-escape - the empty string.
          else if isAbsolute || s == "" then
            "/"
          # A relative path that reduces to nothing (e.g. "."), which has no
          # valid escaping.
          else
            notNormalized;
      in
      slashesToDashes (replacePrefix "." escapeLeadingDot (escapeChar simplifiedPath));

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
              "${name} = ($ENV.secret${toString index}${optionalString (!secrets.${name}.quote) " | fromjson"})"
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

    /*
      Mapping of systems to “magicOrExtension” and “mask”. Mostly taken from:
      - https://github.com/cleverca22/nixos-configs/blob/master/qemu.nix
      and
      - https://github.com/qemu/qemu/blob/master/scripts/qemu-binfmt-conf.sh
    */
    binfmtMagics = import ./binfmt-magics.nix;

    # Utilities for working with the security.pam module (pam.nix)
    pam = {
      /*
        Set up the ordering for a set of PAM rules using an ordered list of rules.

        The input is an ordered list of PAM rules. Each rule is an attrset similar to the options
        in `security.pam.services.<service>.rules.<rule>`, with two modifications:

        1. The `order` option may not be given.
        2. The `name` option is required.

        The output is an attrset of rules suitable for `security.pam.services.<service>.rules`.

        The `order` option on the resulting rules will automatically be configured according to the
        (implied) ordering of the input rules.
      */
      autoOrderRules = lib.flip lib.pipe [
        (lib.imap1 (
          index: rule:
          assert lib.assertMsg (!rule ? order) "the 'order' option may not be set when using autoOrderRules";
          rule // { order = lib.mkDefault (10000 + index * 100); }
        ))
        (map (rule: lib.nameValuePair rule.name (removeAttrs rule [ "name" ])))
        lib.listToAttrs
      ];
    };

    /**
      Creates a per-module `stateRevision` option that takes an int value, with a
      default that is derived from `system.stateVersion`.

      # Inputs

      `descriptionName`
      : A human-friendly name for your module, used for the description of the
        created option.

      `migrations`
      : Attribute set that maps from values of `system.stateVersion`
        (representing the breakpoints at which the default value of this option
        will change) to Markdown instructions to users for manually migrating
        their data to this breakpoint. The migration instructions will be
        included in the NixOS documentation for this option. (These instructions
        must only contain Markdown inlines, because they will be rendered in a
        table. In particular, lists will not render correctly.)

        `migrations` will also be exposed as an attribute on the result.

      # Examples
      :::{.example}
      ## `lib.options.mkStateRevisionOption` usage example

      ```nix
      exampleModule =
        { lib, config, utils, ... }:
        {
          options.services.whatever = {
            stateRevision = utils.mkStateRevisionOption {
              descriptionName = "the whatever service";
              migrations = {
                "26.05" = "Rename `/var/lib/old_name` to `/var/lib/new_name`.";
                "26.11" = "Run the `upgrade_whatever` utility.";
                };
              };
            };
          };
        }

      (pkgs.nixos [
        exampleModule
        { system.stateVersion = "25.11"; }
      ]).config.services.whatever.stateRevision # => 0
      (pkgs.nixos [
        exampleModule
        { system.stateVersion = "26.05"; }
      ]).config.services.whatever.stateRevision # => 1
      (pkgs.nixos [
        exampleModule
        { system.stateVersion = "27.05"; }
      ]).config.services.whatever.stateRevision # => 2
      ```

      :::

      Modules should use this function when they change how data managed by the
      module is persisted on the system between NixOS releases.

      The default value of the option will be the number of attributes in the
      `migrations` parameter with name less than or equal to the value of
      `system.stateVersion`.

      When using this function, don't forget to add the option's value to
      `system.moduleStateRevisions."your.module.stateRevision"` when your module is
      enabled.
    */
    mkStateRevisionOption =
      {
        descriptionName,
        migrations,
      }:
      let
        versions = attrNames migrations;
        maxVal = length versions;
      in
      assert all (v: builtins.match "[0-9]{2}\\.[0-9]{2}" v != null) versions;
      mkOption {
        type = types.ints.between 0 maxVal;
        description = ''
          This option versions the format of state persisted by
          ${descriptionName}. Its default value depends on the value of
          {option}`system.stateVersion`.

          Users who wish to increment this option will need to take manual
          migration steps to preserve their data. **If you perform these
          migrations, rolling back to an older generation will require also
          reversing the migrations to the state expected by that generation.**
          The migrations needed to advance to each value of this option are as
          follows (perform all instructions after the row for the current
          `stateRevision`, up to and including the row for the new
          `stateRevision`):

          | `stateRevision` | Migration instructions |
          |-----------------|------------------------|
          | 0               | (none)                 |
          ${concatImapStringsSep "\n" (
            v: sv: "| ${toString v} | ${replaceStrings [ "\n" ] [ " " ] migrations.${sv}} |"
          ) versions}

          Note that you do **not** need to change {option}`system.stateVersion`
          in order to update this option. {option}`system.stateVersion` only
          determines the default value of this option. Most users should not
          change {option}`system.stateVersion` at all.
        '';
        default = findFirstIndex (versionOlder config.system.stateVersion) maxVal versions;
        defaultText = literalMD ''
          If {option}`system.stateVersion` is:
          ${concatImapStringsSep "\n" (v: sv: "* &lt;${sv}: ${toString (v - 1)}") versions}
          * otherwise: ${toString maxVal}
        '';
      }
      // {
        inherit migrations;
      };
  };
in
utils
