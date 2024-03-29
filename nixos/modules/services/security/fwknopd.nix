{ config, lib, pkgs, ... }:

let
  cfg = config.services.fwknopd;

  ## Transform an attrset to a fwknopd config file.
  toFwknopd = kv:
    let renderKeyValue = k: v:
          if v != null && v != [] then k + " " + renderValue v + "\n"
          else "";
        renderValue = v:
          let err = t: v: abort
            ("toFwknopd: " +
             "${t} not supported: ${lib.toPretty {} v}");
          in   if lib.isInt      v then toString v
          else if lib.isString   v then v
          else if true  ==       v then "Y"
          else if false ==       v then "N"
          else if lib.isList     v then lib.concatStringsSep "," (map toString v)
          else if lib.isAttrs    v then err "attrsets" v
          else if lib.isFunction v then err "functions" v
          else err "this value of type '${__typeOf v}' is" (toString v);
    in lib.concatStrings (lib.mapAttrsToList renderKeyValue kv) + "\n";

  configAttrs =
    {
      ENABLE_DIGEST_PERSISTENCE = true;
      ENABLE_SPA_PACKET_AGING   = true;
      ENABLE_CMD_SUDO_EXEC      = true;
      MAX_SPA_PACKET_AGE        = cfg.maxSpaPacketAge;
      PCAP_FILTER               = cfg.pcapFilter;
      ENABLE_PCAP_PROMISC       = !cfg.disablePcapPromisc;
    } // lib.optionalAttrs (cfg.tcpServerPort != null) {
      ENABLE_TCP_SERVER         = true;
      TCP_SERVER_PORT           = cfg.tcpServerPort;
    } // lib.optionalAttrs (cfg.udpServerPort != null) {
      ENABLE_UDP_SERVER         = true;
      UDP_SERVER_PORT           = cfg.udpServerPort;
    } // cfg.extraRawConfig;

  configRendered = toFwknopd configAttrs;

  accessSectionAttrs =
    name: section:
    with section;
    {
      SOURCE                 = name;
      DESTINATION            = destination;
      OPEN_PORTS             = openPorts;
      RESTRICT_PORTS         = restrictPorts;
      FW_ACCESS_TIMEOUT      = fwAccessTimeout;
      ACCESS_EXPIRE          = accessExpire;
      ACCESS_EXPIRE_EPOCH    = accessExpireEpoch;
      CMD_CYCLE_OPEN         = cmdCycleOpen;
      CMD_CYCLE_CLOSE        = cmdCycleClose;
      CMD_CYCLE_TIMER        = cmdCycleTimer;
      REQUIRE_USERNAME       = requireUsername;
      REQUIRE_SOURCE_ADDRESS = requireSourceAddress;
    };

  accessRendered' = lib.mapAttrsToList (name: sectn: toFwknopd (accessSectionAttrs name sectn) + "\n\n") cfg.access
                    ++ [("\n" + lib.concatStringsSep "\n" (map (f: "%include ${f}") cfg.accessInclude))];
  accessRendered = lib.concatStringsSep "\n" accessRendered';

  inherit (lib) types;
in

{

  ###### interface

  options = {

    services.fwknopd = {

      enable = lib.mkEnableOption "the fwknopd daemon";

      interface = lib.mkOption {
        type = types.str;
        default = null;
        description = "Network interface to listen on.";
      };

      disablePcapPromisc = lib.mkOption {
        type = types.nullOr types.bool;
        default = true;
        description = "By default fwknopd puts the pcap interface into promiscuous mode. This disables the promiscuity.";
      };

      pcapFilter = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "For promiscuous mode:  override the default PCAP filter.";
      };

      udpServerPort = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Enable UDP server on this port.";
      };

      tcpServerPort = lib.mkOption {
        type = types.nullOr types.int;
        default = null;
        description = "Enable TCP server on this port.";
      };

      test = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Test mode: no firewall changes.";
      };

      verbose = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Verbose logging.";
      };

      maxSpaPacketAge = lib.mkOption {
        type = types.int;
        default = 120;
        description = "Defines the maximum age (in seconds) that an SPA packet will be accepted. This requires that the client system is in relatively close time synchronization with the fwknopd server system (NTP is good). The default age is 120 seconds (two minutes)";
      };

      extraRawConfig = lib.mkOption {
        type = types.attrs;
        default = {};
        description = "A verbatim, dictionary-based passthrough for the options.";
      };

      accessInclude = lib.mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of file paths to include in access.conf.";
      };

      extraRawAccess = lib.mkOption {
        type = types.attrs;
        default = {};
        description = "A verbatim, dictionary-based passthrough for the access file.";
      };

      access = lib.mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            destination = lib.mkOption {
              type = types.str;
              default = "ANY";
              description = "Address of arrival of the knock.";
            };
            openPorts = lib.mkOption {
              type = types.listOf types.int;
              default = [];
              description = "Ports to open on successful knock.";
            };
            restrictPorts = lib.mkOption {
              type = types.listOf types.int;
              default = [];
              description = "Ports to close on successful knock.";
            };
            fwAccessTimeout = lib.mkOption {
              type = types.int;
              default = null;
              description = "How many seconds to keep the access open.";
            };
            accessExpire = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Ignore knocks after MM/DD/YYYY.";
            };
            accessExpireEpoch = lib.mkOption {
              type = types.nullOr types.int;
              default = null;
              description = "Ignore knocks after Unix epoch time.";
            };
            cmdCycleOpen = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Command to execute on a successful knock.";
            };
            cmdCycleClose = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Command to execute on a successful knock, after cmdCycleTimer expires.";
            };
            cmdCycleTimer = lib.mkOption {
              type = types.nullOr types.int;
              default = null;
              description = "How many seconds to wait, before invoking cmdCycleClose.";
            };
            requireUsername = lib.mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Require a user name to be specified in the knock packet.";
            };
            requireSourceAddress = lib.mkOption {
              type = types.nullOr types.bool;
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

  config = lib.mkIf cfg.enable {

    warnings = lib.mkIf (cfg.test == true) [
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
        ExecStart = "${pkgs.fwknop}/bin/fwknopd " +
          (lib.cli.toGNUCommandLineShell { } {
            inherit (cfg) interface test verbose;
            sudo-exe = "/run/wrappers/bin/sudo";
            foreground = true;
            run-dir = "/var/lib/fwknopd";
            config-file = pkgs.writeText "fwknopd.conf" configRendered;
            access-file = pkgs.writeText "fwknopd-access.conf" accessRendered;
          });
      };
    };
  };
}
