{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.nylon;

  homeDir = "/var/lib/nylon";

  configFile =
    cfg:
    pkgs.writeText "nylon-${cfg.name}.conf" ''
      [General]
      No-Simultaneous-Conn=${toString cfg.nrConnections}
      Log=${if cfg.logging then "1" else "0"}
      Verbose=${if cfg.verbosity then "1" else "0"}

      [Server]
      Binding-Interface=${cfg.acceptInterface}
      Connecting-Interface=${cfg.bindInterface}
      Port=${toString cfg.port}
      Allow-IP=${lib.concatStringsSep " " cfg.allowedIPRanges}
      Deny-IP=${lib.concatStringsSep " " cfg.deniedIPRanges}
    '';

  nylonOpts =
    { name, ... }:
    {

      options = {

        enable = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enables nylon as a running service upon activation.
          '';
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "";
          description = "The name of this nylon instance.";
        };

        nrConnections = lib.mkOption {
          type = lib.types.int;
          default = 10;
          description = ''
            The number of allowed simultaneous connections to the daemon, default 10.
          '';
        };

        logging = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable logging, default is no logging.
          '';
        };

        verbosity = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Enable verbose output, default is to not be verbose.
          '';
        };

        acceptInterface = lib.mkOption {
          type = lib.types.str;
          default = "lo";
          description = ''
            Tell nylon which interface to listen for client requests on, default is "lo".
          '';
        };

        bindInterface = lib.mkOption {
          type = lib.types.str;
          default = "enp3s0f0";
          description = ''
            Tell nylon which interface to use as an uplink, default is "enp3s0f0".
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 1080;
          description = ''
            What port to listen for client requests, default is 1080.
          '';
        };

        allowedIPRanges = lib.mkOption {
          type = with lib.types; listOf str;
          default = [
            "192.168.0.0/16"
            "127.0.0.1/8"
            "172.16.0.1/12"
            "10.0.0.0/8"
          ];
          description = ''
            Allowed client IP ranges are evaluated first, defaults to ARIN IPv4 private ranges:
              [ "192.168.0.0/16" "127.0.0.0/8" "172.16.0.0/12" "10.0.0.0/8" ]
          '';
        };

        deniedIPRanges = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ "0.0.0.0/0" ];
          description = ''
            Denied client IP ranges, these gets evaluated after the allowed IP ranges, defaults to all IPv4 addresses:
              [ "0.0.0.0/0" ]
            To block all other access than the allowed.
          '';
        };
      };
      config = {
        name = lib.mkDefault name;
      };
    };

  mkNamedNylon = cfg: {
    "nylon-${cfg.name}" = {
      description = "Nylon, a lightweight SOCKS proxy server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "nylon";
        Group = "nylon";
        WorkingDirectory = homeDir;
        ExecStart = "${pkgs.nylon}/bin/nylon -f -c ${configFile cfg}";
      };
    };
  };

  anyNylons = lib.collect (p: p ? enable) cfg;
  enabledNylons = lib.filter (p: p.enable == true) anyNylons;
  nylonUnits = map (nylon: mkNamedNylon nylon) enabledNylons;

in

{

  ###### interface

  options = {

    services.nylon = lib.mkOption {
      default = { };
      description = "Collection of named nylon instances";
      type = with lib.types; attrsOf (submodule nylonOpts);
      internal = true;
    };

  };

  ###### implementation

  config = lib.mkIf (enabledNylons != [ ]) {

    users.users.nylon = {
      group = "nylon";
      description = "Nylon SOCKS Proxy";
      home = homeDir;
      createHome = true;
      uid = config.ids.uids.nylon;
    };

    users.groups.nylon.gid = config.ids.gids.nylon;

    systemd.services = lib.foldr (a: b: a // b) { } nylonUnits;

  };
}
