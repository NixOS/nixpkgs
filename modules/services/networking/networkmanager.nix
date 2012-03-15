{ config, pkgs, ... }:

with pkgs.lib;

let

  stateDir = "/var/lib/NetworkManager";

in

{

  ###### interface

  options = {

    networking.networkmanager.enable = mkOption {
      default = false;
      merge = mergeEnableOption;
      description = ''
        Whether to use NetworkManager to obtain an IP adress and other
        configuration for all network interfaces that are not manually
        configured.
      '';
    };

    networking.networkmanager.packages = mkOption {
      default = [ pkgs.networkmanager ];
      description =
        ''
          Packages providing NetworkManager plugins.
        '';
    };
  };


  ###### implementation

  config = mkIf config.networking.networkmanager.enable {

    jobs.networkmanager =
      { startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        script =
          ''
            mkdir -m 755 -p /etc/NetworkManager
            mkdir -m 700 -p /etc/NetworkManager/system-connections
            mkdir -m 755 -p ${stateDir}

            if [[ ! -f /etc/NetworkManager/NetworkManager.conf ]]; then
            cat <<-EOF > /etc/NetworkManager/NetworkManager.conf
            [main]
            plugins=keyfile
            EOF
            fi

            exec ${pkgs.networkmanager}/sbin/NetworkManager --no-daemon
          '';
      };

    environment.systemPackages = config.networking.networkmanager.packages;
    services.dbus.packages = config.networking.networkmanager.packages;
    networking.useDHCP = false;

    environment.etc = [
      {
        source = pkgs.writeScript "01nixos-ip-up"
          ''
          #!/bin/sh
          if test "$2" = "up"; then
            ${pkgs.upstart}/sbin/initctl emit ip-up "IFACE=$1"
          fi
          '';
        target = "NetworkManager/dispatcher.d/01nixos-ip-up";
      }
    ];
  };
}

