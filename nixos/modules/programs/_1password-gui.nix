{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs._1password-gui;

in
{
  options = {
    programs._1password-gui = {
      enable = mkEnableOption "the 1Password GUI application";

      gid = mkOption {
        type = types.addCheck types.int (x: x >= 1000);
        example = literalExpression "5000";
        description = ''
          The gid to assign to the onepassword group, which is needed for browser integration.
          It must be 1000 or greater.
        '';
      };

      polkitPolicyOwners = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = literalExpression ''["user1" "user2" "user3"]'';
        description = ''
          A list of users who should be able to integrate 1Password with polkit-based authentication mechanisms.
        '';
      };

      package = mkPackageOption pkgs "1Password GUI" {
        default = [ "_1password-gui" ];
      };
    };
  };

  config =
    let
      package = cfg.package.override {
        polkitPolicyOwners = cfg.polkitPolicyOwners;
      };
    in
    mkIf cfg.enable {
      environment.systemPackages = [ package ];
      users.groups.onepassword.gid = cfg.gid;

      security.wrappers = {
        "1Password-BrowserSupport" = {
          source = "${package}/share/1password/1Password-BrowserSupport";
          owner = "root";
          group = "onepassword";
          setuid = false;
          setgid = true;
        };

        "1Password-KeyringHelper" = {
          source = "${package}/share/1password/1Password-KeyringHelper";
          owner = "root";
          group = "onepassword";
          setuid = true;
          setgid = true;
        };
      };

    };
}
