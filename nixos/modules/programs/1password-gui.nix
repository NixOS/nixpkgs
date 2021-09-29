{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs._1password-gui;

in
{
  options = {
    programs._1password-gui = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to install 1password-gui with systme-authentication.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs._1password-gui;
        defaultText = literalExample "pkgs._1password-gui";
        description = "Package providing <command>1password</command>.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    security = {
      pam.services.polkit-1.fprintAuth = true;
      polkit.enable = true;

      wrappers = {
        _1password-keyring-helper = {
          source = "${cfg.package.out}/share/1password/1Password-KeyringHelper-Real";
          owner = "root";
          group = "onepassword";
          setuid = true;
        };
      };
    };

    services.gnome.gnome-keyring.enable = true;

    users.groups.onepassword = {};
  };
}
