{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.firewalld;

in {
  ###### interface

  options = {
    networking.firewalld = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            Whether to enable firewalld.  firewalld is a high-level Linux-based packet
            filtering framework intended for desktop use cases.

            This conflicts with the standard networking firewall, so make sure to
            disable it before using firewalld.
          '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [{
      assertion = config.networking.firewall.enable == false;
      message = "You can not use firewalld with services.networking.firewall.";
    }];

    environment.etc = [
    { source = "${pkgs.firewalld}/etc/firewalld";
      target = "firewalld"; }
    ];

    services = {
      dbus.packages = with pkgs; [ firewalld ];
    };

    systemd = {
      packages = with pkgs; [ firewalld ];

      services.firewalld = {
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}
