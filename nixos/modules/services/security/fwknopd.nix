{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.fwknopd;

  configFile = pkgs.writeText "fwknopd.conf"
    (with cfg;
      (''
         ENABLE_DIGEST_PERSISTENCE Y
         ENABLE_SPA_PACKET_AGING Y
         ENABLE_CMD_SUDO_EXEC Y
         MAX_SPA_PACKET_AGE ${toString maxSpaPacketAge}
       ''
       + optionalString (pcapFilter != null)
       ''
         PCAP_FILTER ${pcapFilter}
       ''
       + optionalString (tcpServerPort == true)
       ''
         ENABLE_TCP_SERVER Y
         TCP_SERVER_PORT ${toString tcpServerPort}
       ''
       + optionalString (udpServerPort != null)
       ''
         ENABLE_UDP_SERVER Y
         UDP_SERVER_PORT ${toString udpServerPort}
       ''
       + optionalString (disablePcapPromisc == true)
       ''
         ENABLE_PCAP_PROMISC N
       ''));

  accessFile = pkgs.writeText "fwknopd-access.conf"
    ''
      ${
        let f = name: cfg:
          with cfg;
          ''
            SOURCE         ${name}
            DESTINATION    ${destination}
          ''
          + optionalString (openPorts != [])
          ''
            OPEN_PORTS     ${concatStringsSep "," (map toString openPorts)}
          ''
          + optionalString (restrictPorts != [])
          ''
            RESTRICT_PORTS ${concatStringsSep "," (map toString restrictPorts)}
          ''
          + optionalString (fwAccessTimeout != null)
          ''
            FW_ACCESS_TIMEOUT ${toString fwAccessTimeout}
          ''
          + optionalString (accessExpire != null)
          ''
            ACCESS_EXPIRE ${accessExpire}
          ''
          + optionalString (accessExpireEpoch != null)
          ''
            ACCESS_EXPIRE_EPOCH ${toString accessExpireEpoch}
          ''
          + optionalString (cmdCycleOpen != null)
          ''
            CMD_CYCLE_OPEN ${cmdCycleOpen}
          ''
          + optionalString (cmdCycleClose != null)
          ''
            CMD_CYCLE_CLOSE ${cmdCycleClose}
          ''
          + optionalString (cmdCycleTimer != null)
          ''
            CMD_CYCLE_TIMER ${toString cmdCycleTimer}
          ''
          + optionalString (requireUsername != null)
          ''
            REQUIRE_USERNAME ${requireUsername}
          ''
          + optionalString (requireSourceAddress == true)
          ''
            REQUIRE_SOURCE_ADDRESS Y
          '';
        in concatStringsSep "\n"
          (mapAttrsToList f cfg.access
           ++
           map (f: "%include ${f}") cfg.accessInclude)
      }
    '';

in

{

  ###### interface

  options = {

    services.fwknopd = with types; {

      enable = mkEnableOption "the fwknopd daemon";

      interface = mkOption {
        type = str;
        default = null;
        description = "Network interface to listen on.";
      };

      disablePcapPromisc = mkOption {
        type = nullOr bool;
        default = true;
        description = "By default fwknopd puts the pcap interface into promiscuous mode. This disables the promiscuity.";
      };

      pcapFilter = mkOption {
        type = nullOr str;
        default = null;
        description = "For promiscuous mode:  override the default PCAP filter.";
      };

      udpServerPort = mkOption {
        type = nullOr int;
        default = null;
        description = "Enable UDP server on this port.";
      };

      tcpServerPort = mkOption {
        type = nullOr int;
        default = null;
        description = "Enable TCP server on this port.";
      };

      test = mkOption {
        type = bool;
        default = false;
        description = "Test mode: no firewall changes.";
      };

      verbose = mkOption {
        type = bool;
        default = false;
        description = "Verbose logging.";
      };

      maxSpaPacketAge = mkOption {
        type = int;
        default = 120;
        description = "Defines the maximum age (in seconds) that an SPA packet will be accepted. This requires that the client system is in relatively close time synchronization with the fwknopd server system (NTP is good). The default age is 120 seconds (two minutes)";
      };

      accessInclude = mkOption {
        type = listOf str;
        default = [];
        description = "List of file paths to include in access.conf.";
      };

      access = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            destination = mkOption {
              type = str;
              default = "ANY";
              description = "Address of arrival of the knock.";
            };
            openPorts = mkOption {
              type = listOf int;
              default = [];
              description = "Ports to open on successful knock.";
            };
            restrictPorts = mkOption {
              type = listOf int;
              default = [];
              description = "Ports to close on successful knock.";
            };
            fwAccessTimeout = mkOption {
              type = int;
              default = null;
              description = "How many seconds to keep the access open.";
            };
            accessExpire = mkOption {
              type = nullOr str;
              default = null;
              description = "Ignore knocks after MM/DD/YYYY.";
            };
            accessExpireEpoch = mkOption {
              type = nullOr int;
              default = null;
              description = "Ignore knocks after Unix epoch time.";
            };
            cmdCycleOpen = mkOption {
              type = nullOr str;
              default = null;
              description = "Command to execute on a successful knock.";
            };
            cmdCycleClose = mkOption {
              type = nullOr str;
              default = null;
              description = "Command to execute on a successful knock, after cmdCycleTimer expires.";
            };
            cmdCycleTimer = mkOption {
              type = nullOr int;
              default = null;
              description = "How many seconds to wait, before invoking cmdCycleClose.";
            };
            requireUsername = mkOption {
              type = nullOr str;
              default = null;
              description = "Require a user name to be specified in the knock packet.";
            };
            requireSourceAddress = mkOption {
              type = nullOr bool;
              default = true;
              description = "Require the real source address to be included in the packet (recommended).";
            };
          };
        });

        description = ''
          Access grants.
        '';
        default = {};
        example = {
          "IP,..,IP/NET,..,NET/ANY" = {
            fwAccessTimeout = 3600;
            cmdCycleOpen = "echo 'Knock, knock!' | systemd-cat";
          };
        };
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    warnings = mkIf (cfg.test == true) [
      "fwknopd operating in test mode!"
    ];

    users.users.fwknopd = {
      home = "/var/lib/fwknopd";
      group = "fwknopd";
      isSystemUser = true;
    };

    users.groups.fwknopd = {};

    systemd.targets.fwknop = {
          wantedBy = [ "multi-user.target" ];
          wants = [ "fwknopd.service" ];
        };
    systemd.services.fwknopd = {
      description = "Single Packet Authorization server: fwknopd";
      documentation = [ "man:fwknopd(8) http://www.cipherdyne.org/fwknop/" ];

      enable = true;
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        User = "fwknopd";
        Group = "fwknopd";
        UMask = 0077;
        StateDirectory = "fwknopd";
        StateDirectoryMode = "700";
        AmbientCapabilities = "CAP_NET_RAW CAP_NET_ADMIN";
        Restart = "on-failure";
        ExecStart = pkgs.writeShellScript "fwknopd-start.sh"
          ''
          ${escapeShellArgs
            ([ "${pkgs.fwknop}/bin/fwknopd"
             "--sudo-exe"    "/run/wrappers/bin/sudo"
             "--foreground"
             "--interface"    cfg.interface
             "--run-dir"     "/var/lib/fwknopd"
             "--config-file" "${configFile}"
             "--access-file" "${accessFile}"
           ]
          ++ optional cfg.test      "--test"
          ++ optional cfg.verbose   "--verbose"
          )}
          '';
      };
    };
  };
}
