{ config, lib, pkgs, ... }:

with lib;

let

  cfg4 = config.services.dhcpd4;
  cfg6 = config.services.dhcpd6;

  writeConfig = postfix: cfg: pkgs.writeText "dhcpd.conf"
    ''
      default-lease-time 600;
      max-lease-time 7200;
      ${optionalString (!cfg.authoritative) "not "}authoritative;
      ddns-update-style interim;
      log-facility local1; # see dhcpd.nix

      ${cfg.extraConfig}

      ${lib.concatMapStrings
          (machine: ''
            host ${machine.hostName} {
              hardware ethernet ${machine.ethernetAddress};
              fixed-address${
                optionalString (postfix == "6") postfix
              } ${machine.ipAddress};
            }
          '')
          cfg.machines
      }
    '';

  dhcpdService = postfix: cfg:
    let
      configFile =
        if cfg.configFile != null
          then cfg.configFile
          else writeConfig postfix cfg;
      leaseFile = "/var/lib/dhcpd${postfix}/dhcpd.leases";
      args = [
        "@${pkgs.dhcp}/sbin/dhcpd" "dhcpd${postfix}" "-${postfix}"
        "-pf" "/run/dhcpd${postfix}/dhcpd.pid"
        "-cf" configFile
        "-lf" leaseFile
      ] ++ cfg.extraFlags
        ++ cfg.interfaces;
    in
      optionalAttrs cfg.enable {
        "dhcpd${postfix}" = {
          description = "DHCPv${postfix} server";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];

          preStart = "touch ${leaseFile}";
          serviceConfig = {
            ExecStart = concatMapStringsSep " " escapeShellArg args;
            Type = "forking";
            Restart = "always";
            DynamicUser = true;
            User = "dhcpd";
            Group = "dhcpd";
            AmbientCapabilities = [
              "CAP_NET_RAW"          # to send ICMP messages
              "CAP_NET_BIND_SERVICE" # to bind on DHCP port (67)
            ];
            StateDirectory   = "dhcpd${postfix}";
            RuntimeDirectory = "dhcpd${postfix}";
            PIDFile = "/run/dhcpd${postfix}/dhcpd.pid";
          };
        };
      };

  machineOpts = { ... }: {

    options = {

      hostName = mkOption {
        type = types.str;
        example = "foo";
        description = lib.mdDoc ''
          Hostname which is assigned statically to the machine.
        '';
      };

      ethernetAddress = mkOption {
        type = types.str;
        example = "00:16:76:9a:32:1d";
        description = lib.mdDoc ''
          MAC address of the machine.
        '';
      };

      ipAddress = mkOption {
        type = types.str;
        example = "192.168.1.10";
        description = lib.mdDoc ''
          IP address of the machine.
        '';
      };

    };
  };

  dhcpConfig = postfix: {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether to enable the DHCPv${postfix} server.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
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
      description = lib.mdDoc ''
        Extra text to be appended to the DHCP server configuration
        file. Currently, you almost certainly need to specify something
        there, such as the options specifying the subnet mask, DNS servers,
        etc.
      '';
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
        Additional command line flags to be passed to the dhcpd daemon.
      '';
    };

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        The path of the DHCP server configuration file.  If no file
        is specified, a file is generated using the other options.
      '';
    };

    interfaces = mkOption {
      type = types.listOf types.str;
      default = ["eth0"];
      description = lib.mdDoc ''
        The interfaces on which the DHCP server should listen.
      '';
    };

    machines = mkOption {
      type = with types; listOf (submodule machineOpts);
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
      description = lib.mdDoc ''
        A list mapping Ethernet addresses to IPv${postfix} addresses for the
        DHCP server.
      '';
    };

    authoritative = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether the DHCP server shall send DHCPNAK messages to misconfigured
        clients. If this is not done, clients may be unable to get a correct
        IP address after changing subnets until their old lease has expired.
      '';
    };

  };

in

{

  imports = [
    (mkRenamedOptionModule [ "services" "dhcpd" ] [ "services" "dhcpd4" ])
  ] ++ flip map [ "4" "6" ] (postfix:
    mkRemovedOptionModule [ "services" "dhcpd${postfix}" "stateDir" ] ''
      The DHCP server state directory is now managed with the systemd's DynamicUser mechanism.
      This means the directory is named after the service (dhcpd${postfix}), created under
      /var/lib/private/ and symlinked to /var/lib/.
    ''
  );

  ###### interface

  options = {

    services.dhcpd4 = dhcpConfig "4";
    services.dhcpd6 = dhcpConfig "6";

  };


  ###### implementation

  config = mkIf (cfg4.enable || cfg6.enable) {

    systemd.services = dhcpdService "4" cfg4 // dhcpdService "6" cfg6;

    warnings = [
      ''
        The dhcpd4 and dhcpd6 modules will be removed from NixOS 23.11, because ISC DHCP reached its end of life.
        See https://www.isc.org/blogs/isc-dhcp-eol/ for details.
        Please switch to a different implementation like kea, systemd-networkd or dnsmasq.
      ''
    ];
  };

}
