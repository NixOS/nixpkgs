{ config, lib, pkgs, ... }:

let
  inherit (lib) mkOption mkIf types;
  cfg = config.programs.phosh-ui;

  oskItem = pkgs.makeDesktopItem {
    name = "sm.puri.OSK0";
    type = "Application";
    desktopName = "On-screen keyboard";
    exec = "${pkgs.squeekboard}/bin/squeekboard";
    categories = "GNOME;Core;";
    extraEntries = ''
      OnlyShowIn=GNOME;
      NoDisplay=true
      X-GNOME-Autostart-Phase=Panel
      X-GNOME-Provides=inputmethod
      X-GNOME-Autostart-Notify=true
      X-GNOME-AutoRestart=true
    '';
  };
in

{
  ###### interface

  options = {
    programs.phosh-ui = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Phosh, related packages and default configurations.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    # https://source.puri.sm/Librem5/phosh/-/issues/303
    security.pam.services.phosh = {
      text = ''
        #
        # /etc/pam.d/phosh - Phosh login
        #
        auth    requisite       pam_nologin.so
        auth    required        pam_succeed_if.so user != root quiet_success
        auth    required        pam_securetty.so
        auth    requisite       pam_nologin.so
        auth    optional        ${pkgs.gnome3.gnome_keyring}/lib/security/pam_gnome_keyring.so
      '';
    };

    security.pam.services.gdm.enableGnomeKeyring = true;

    environment.systemPackages = [ pkgs.phoc pkgs.phosh pkgs.squeekboard oskItem ];
  };

}
