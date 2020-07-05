{ config, lib, pkgs, ... }:

let
  inherit (lib) mkEnableOption mkIf types;
  cfg = config.programs.phosh-ui;

  # Based on https://source.puri.sm/Librem5/librem5-base/-/blob/4596c1056dd75ac7f043aede07887990fd46f572/default/sm.puri.OSK0.desktop
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
      enable = mkEnableOption ''
        Whether to enable, Phosh, related packages and default configurations.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    # https://source.puri.sm/Librem5/phosh/-/issues/303
    security.pam.services.phosh = {
      text = ''
        auth    requisite       pam_nologin.so
        auth    required        pam_succeed_if.so user != root quiet_success
        auth    required        pam_securetty.so
        auth    requisite       pam_nologin.so
      '';
    };

    services.gnome3.gnome-keyring.enable = true;

    environment.systemPackages = [
      pkgs.phoc
      pkgs.phosh
      pkgs.squeekboard
      oskItem
    ];
  };

}
