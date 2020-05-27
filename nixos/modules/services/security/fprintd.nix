{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.fprintd;

in


{

  ###### interface

  options = {

    services.fprintd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable fprintd daemon and PAM module for fingerprint readers handling.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.fprintd;
        defaultText = "pkgs.fprintd";
        description = ''
          fprintd package to use.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.dbus.packages = [ pkgs.fprintd ];

    environment.systemPackages = [ pkgs.fprintd ];

    systemd.packages = [ cfg.package ];

  };

}
