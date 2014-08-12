{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.dhcpd;

  stateDir = "/var/lib/dhcp"; # Don't use /var/state/dhcp; not FHS-compliant.

  configFile = if cfg.configFile != null then cfg.configFile else pkgs.writeText "dhcpd.conf"
    ''
      default-lease-time 600;
      max-lease-time 7200;
      authoritative;
      ddns-update-style ad-hoc;
      log-facility local1; # see dhcpd.nix

      ${cfg.extraConfig}

      ${lib.concatMapStrings
          (machine: ''
            host ${machine.hostName} {
              hardware ethernet ${machine.ethernetAddress};
              fixed-address ${machine.ipAddress};
            }
          '')
          cfg.machines
      }
    '';

in

{

  ###### interface

  options = {

    services.dhcpd = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the DHCP server.
        ";
      };

      extraConfig = mkOption {
        default = "";
        example = ''
          option subnet-mask 255.255.255.0;
          option broadcast-address 192.168.1.255;
          option routers 192.168.1.5;
          option domain-name-servers 130.161.158.4, 130.161.33.17, 130.161.180.1;
          option domain-name "example.org";
          subnet 192.168.1.0 netmask 255.255.255.0 {
            range 192.168.1.100 192.168.1.200;
          }
        '';
        description = "
          Extra text to be appended to the DHCP server configuration
          file.  Currently, you almost certainly need to specify
          something here, such as the options specifying the subnet
          mask, DNS servers, etc.
        ";
      };

      configFile = mkOption {
        default = null;
        description = "
          The path of the DHCP server configuration file.  If no file
          is specified, a file is generated using the other options.
        ";
      };

      interfaces = mkOption {
        default = ["eth0"];
        description = "
          The interfaces on which the DHCP server should listen.
        ";
      };

      machines = mkOption {
        default = [];
        example = [
          { hostName = "foo";
            ethernetAddress = "00:16:76:9a:32:1d";
            ipAddress = "192.168.1.10";
          }
          { hostName = "bar";
            ethernetAddress = "00:19:d1:1d:c4:9a";
            ipAddress = "192.168.1.11";
          }
        ];
        description = "
          A list mapping ethernet addresses to IP addresses for the
          DHCP server.
        ";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.dhcpd.enable {

    jobs.dhcpd =
      { description = "DHCP server";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        script =
          ''
            mkdir -m 755 -p ${stateDir}

            touch ${stateDir}/dhcpd.leases

            exec ${pkgs.dhcp}/sbin/dhcpd -f -cf ${configFile} \
                -lf ${stateDir}/dhcpd.leases \
                ${toString cfg.interfaces}
          '';
      };

  };

}
