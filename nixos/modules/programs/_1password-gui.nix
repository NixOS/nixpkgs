{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs._1password-gui;

in
{
  imports = [
    (mkRemovedOptionModule [ "programs" "_1password-gui" "gid" ] ''
      A preallocated GID will be used instead.
    '')
  ];

  options = {
    programs._1password-gui = {
      enable = mkEnableOption "the 1Password GUI application";

      polkitPolicyOwners = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = literalExpression ''["user1" "user2" "user3"]'';
        description = lib.mdDoc ''
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
      users.groups.onepassword.gid = config.ids.gids.onepassword;

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
