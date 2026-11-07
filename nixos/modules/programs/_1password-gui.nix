{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs._1password-gui;
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "programs" "_1password-gui" "gid" ] ''
      A preallocated GID will be used instead.
    '')
  ];

  options = {
    programs._1password-gui = {
      enable = lib.mkEnableOption "the 1Password GUI application";

      customAllowedBrowsers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = lib.literalExpression ''["opera" "vivaldi-bin"]'';
        description = ''
          By default, the 1Password browser extension will connect to the 1Password app in many common web browsers, including Chrome, Firefox, Edge, Brave, and Arc. If you want to connect the 1Password app to an unsupported browser, you can specify additional browsers using this option.
          Refer to <https://support.1password.com/additional-browsers/?linux> for more information.
        '';
      };

      polkitPolicyOwners = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = lib.literalExpression ''["user1" "user2" "user3"]'';
        description = ''
          A list of users who should be able to integrate 1Password with polkit-based authentication mechanisms.
        '';
      };

      package =
        lib.mkPackageOption pkgs "1Password GUI" {
          default = [ "_1password-gui" ];
        }
        // {
          apply =
            pkg:
            pkg.override {
              inherit (cfg) polkitPolicyOwners;
            };
        };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    users.groups.onepassword.gid = config.ids.gids.onepassword;

    environment.etc."1password/custom_allowed_browsers" = lib.mkIf (cfg.customAllowedBrowsers != [ ]) {
      text = lib.concatStringsSep "\n" cfg.customAllowedBrowsers;
      mode = "0644";
    };

    security.wrappers = {
      "1Password-BrowserSupport" = {
        source = "${cfg.package}/share/1password/1Password-BrowserSupport";
        owner = "root";
        group = "onepassword";
        setuid = false;
        setgid = true;
      };
    };
  };
}
