{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.google-chrome;
in
{
  options.programs.google-chrome = {
    enable = lib.mkEnableOption "Google Chrome browser";
    package = lib.mkPackageOption pkgs "google-chrome" { };

    extensions = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      ];
      description = "List of Chrome extension IDs to force install.";
    };

    commandLineArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--disable-gpu"
        "--enable-features=VaapiVideoDecoder"
      ];
      description = "Extra command line arguments passed to Google Chrome.";
    };

    policies = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      example = {
        HomepageLocation = "https://nixos.org";
        PasswordManagerEnabled = false;
      };
      description = "Chrome enterprise policies written to managed policies JSON.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (cfg.package.override {
        commandLineArgs = cfg.commandLineArgs;
      })
    ];

    environment.etc."opt/chrome/policies/managed/nixos.json".text =
      let
        extensionList = map (id: "${id};https://clients2.google.com/service/update2/crx") cfg.extensions;

        finalPolicies = lib.recursiveUpdate cfg.policies (
          lib.optionalAttrs (cfg.extensions != [ ]) {
            ExtensionInstallForcelist = extensionList;
          }
        );
      in
      builtins.toJSON finalPolicies;

    environment.sessionVariables.GOOGLE_CHROME_EXTRA_ARGS = lib.concatStringsSep " " cfg.commandLineArgs;
  };
}
