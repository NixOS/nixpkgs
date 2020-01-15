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
        example = "pkgs.fprintd-thinkpad";
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


    # The upstream unit does not use StateDirectory, and will
    # fail if the directory it needs is not present. Should be
    # fixed when https://gitlab.freedesktop.org/libfprint/fprintd/merge_requests/5
    # is merged.
    systemd.services.fprintd.serviceConfig.StateDirectory = "fprint";

  };

}
