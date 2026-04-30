{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkFirefoxBaseModule =
    {
      variant,
      prettyName,
      defaultPackage,
      relatedPackages ? [ ],
    }:
    let
      cfg = config.programs."${variant}";

      policyFormat = pkgs.formats.json { };

      organisationInfo = ''
        When this option is in use, ${prettyName} will inform you that "your browser
        is managed by your organisation". That message appears because NixOS
        installs what you have declared here such that it cannot be overridden
        through the user interface. It does not mean that someone else has been
        given control of your browser, unless of course they also control your
        NixOS configuration.
      '';
    in
    {
      options.programs."${variant}" = {
        enable = lib.mkEnableOption "the ${prettyName} web browser";

        package = lib.mkOption {
          type = lib.types.package;
          default = defaultPackage;
          description = "${prettyName} package to use.";
          defaultText = lib.literalExpression "pkgs.${variant}";
          inherit relatedPackages;
        };

        finalPackage = lib.mkOption {
          type = lib.types.package;
          visible = false;
          readOnly = true;
          description = "Resulting customized ${prettyName} package.";
        };

        wrapperConfig = lib.mkOption {
          type = lib.types.attrs;
          default = { };
          description = "Arguments to pass to ${prettyName} wrapper";
        };

        policies = lib.mkOption {
          type = policyFormat.type;
          default = { };
          description = ''
            Group policies to install.

            See [Mozilla's documentation](https://mozilla.github.io/policy-templates/)
            for a list of available options.

            This can be used to install extensions declaratively! Check out the
            documentation of the `ExtensionSettings` policy for details.

            ${organisationInfo}
          '';
        };

        preferences = lib.mkOption {
          type =
            with lib.types;
            attrsOf (oneOf [
              bool
              int
              str
            ]);
          default = { };
          description = ''
            Preferences to set from `about:config`.

            Some of these might be able to be configured more ergonomically
            using policies.

            See [here](https://mozilla.github.io/policy-templates/#preferences) for allowed preferences.

            ${organisationInfo}
          '';
          example = lib.literalExpression ''
            {
              "browser.tabs.tabmanager.enabled" = false;
            }
          '';
        };

        preferencesStatus = lib.mkOption {
          type = lib.types.enum [
            "default"
            "locked"
            "user"
            "clear"
          ];
          default = "locked";
          description = ''
            The status of `${variant}.preferences`.

            `status` can assume the following values:
            - `"default"`: Preferences appear as default.
            - `"locked"`: Preferences appear as default and can't be changed.
            - `"user"`: Preferences appear as changed.
            - `"clear"`: Value has no effect. Resets to factory defaults on each startup.
          '';
        };

        autoConfig = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
            AutoConfig files can be used to set and lock preferences that are not covered
            by the policies.json for Mac and Linux. This method can be used to automatically
            change user preferences or prevent the end user from modifying specific
            preferences by locking them. More info can be found in <https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig>.
          '';
        };

        autoConfigFiles = lib.mkOption {
          type = with lib.types; listOf path;
          default = [ ];
          description = ''
            AutoConfig files can be used to set and lock preferences that are not covered
            by the policies.json for Mac and Linux. This method can be used to automatically
            change user preferences or prevent the end user from modifying specific
            preferences by locking them. More info can be found in <https://support.mozilla.org/en-US/kb/customizing-firefox-using-autoconfig>.

            Files are concatenated and autoConfig is appended.
          '';
        };

        nativeMessagingHosts.packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = [ ];
          description = ''
            Additional packages containing native messaging hosts that should be made available to ${prettyName} extensions.
          '';
        };
      };

      config = lib.mkIf cfg.enable {
        environment.systemPackages = [
          cfg.finalPackage
        ];

        environment.etc =
          let
            policiesJSON = policyFormat.generate "${variant}-policies.json" { inherit (cfg) policies; };
          in
          lib.mkIf (cfg.policies != { }) {
            "${variant}/policies/policies.json".source = "${policiesJSON}";
          };

        # Preferences are converted into a policy
        programs.${variant} = {
          policies = {
            DisableAppUpdate = true;
            Preferences = (
              builtins.mapAttrs (_: value: {
                Value = value;
                Status = cfg.preferencesStatus;
              }) cfg.preferences
            );
          };
          finalPackage = cfg.package.override (old: {
            extraPrefsFiles =
              (old.extraPrefsFiles or [ ])
              ++ cfg.autoConfigFiles
              ++ [ (pkgs.writeText "${variant}-autoconfig.js" cfg.autoConfig) ];
            nativeMessagingHosts = (old.nativeMessagingHosts or [ ]) ++ cfg.nativeMessagingHosts.packages;
            cfg = (old.cfg or { }) // cfg.wrapperConfig;
          });
        };
      };
    };
in
{
  imports = [
    (import ./firefox.nix mkFirefoxBaseModule)
    (import ./librewolf.nix mkFirefoxBaseModule)
  ];

  meta.maintainers = with lib.maintainers; [
    danth
    linsui
  ];
}
