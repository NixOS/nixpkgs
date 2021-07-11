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
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs._1password-gui ];

    security = {
      pam.services.polkit-1.fprintAuth = true;
      polkit.enable = true;

      wrappers = {
        /*_1password-chrome-sandbox = {
          source = "${pkgs._1password-gui.out}/share/1password/chrome-sandbox";
          permissions = "u+rwx,g+rx,o-rx";
        };*/

        _1password-keyring-helper = {
          #source = "${pkgs._1password-gui.out}/share/1password/1Password-KeyringHelper";
          source = "${pkgs._1password-gui.out}/share/1password/1Password-KeyringHelper2";
          owner = "root";
          group = "onepassword";
          permissions = "u+rxs,g+rxs,o+rx";
          capabilities = "cap_setpcap+ep";
        };
      };
    };

    services.gnome.gnome-keyring.enable = true;

    users.groups.onepassword = {};
  };
}
