{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nylas-mail;
  defaultUser = "nylas-mail";
in {
  ###### interface
  options = {
    services.nylas-mail = {

      enable = mkEnableOption ''
        nylas-mail - Open-source mail client built on the modern web with Electron, React, and Flux
      '';

      gnome3-keyring = mkOption {
        type = types.bool;
        default = true;
        description = "Enable gnome3 keyring for nylas-mail.";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.nylas-mail-bin ];

    services.gnome3.gnome-keyring = mkIf cfg.gnome3-keyring {
      enable = true;
    };

  };
}
