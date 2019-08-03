{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.nylon;

  homeDir = "/var/lib/nylon";

  configFile = cfg: pkgs.writeText "nylon-${cfg.name}.conf" ''
    [General]
    No-Simultaneous-Conn=${toString cfg.nrConnections}
    Log=${if cfg.logging then "1" else "0"}
    Verbose=${if cfg.verbosity then "1" else "0"}

    [Server]
    Binding-Interface=${cfg.acceptInterface}
    Connecting-Interface=${cfg.bindInterface}
    Port=${toString cfg.port}
    Allow-IP=${concatStringsSep " " cfg.allowedIPRanges}
    Deny-IP=${concatStringsSep " " cfg.deniedIPRanges}
  '';

  nylonOpts = { name, ... }: {

    options = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables nylon as a running service upon activation.
        '';
      };

      name = mkOption {
        type = types.str;
        default = "";
        description = "The name of this nylon instance.";
      };

      nrConnections = mkOption {
        type = types.int;
        default = 10;
        description = ''
          The number of allowed simultaneous connections to the daemon, default 10.
        '';
      };

      logging = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable logging, default is no logging.
        '';
      };

      verbosity = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable verbose output, default is to not be verbose.
        '';
      };

      acceptInterface = mkOption {
        type = types.string;
        default = "lo";
        description = ''
          Tell nylon which interface to listen for client requests on, default is "lo".
        '';
      };

      bindInterface = mkOption {
        type = types.string;
        default = "enp3s0f0";
        description = ''
          Tell nylon which interface to use as an uplink, default is "enp3s0f0".
        '';
      };

      port = mkOption {
        type = types.int;
        default = 1080;
        description = ''
          What port to listen for client requests, default is 1080.
        '';
      };

      allowedIPRanges = mkOption {
        type = with types; listOf string;
        default = [ "192.168.0.0/16" "127.0.0.1/8" "172.16.0.1/12" "10.0.0.0/8" ];
        description = ''
           Allowed client IP ranges are evaluated first, defaults to ARIN IPv4 private ranges:
             [ "192.168.0.0/16" "127.0.0.0/8" "172.16.0.0/12" "10.0.0.0/8" ]
        '';
      };

      deniedIPRanges = mkOption {
        type = with types; listOf string;
        default = [ "0.0.0.0/0" ];
        description = ''
          Denied client IP ranges, these gets evaluated after the allowed IP ranges, defaults to all IPv4 addresses:
            [ "0.0.0.0/0" ]
          To block all other access than the allowed.
        '';
      };
    };
    config = { name = mkDefault name; };
  };

  mkNamedNylon = cfg: {
    "nylon-${cfg.name}" = {
      description = "Nylon, a lightweight SOCKS proxy server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
      {
        User = "nylon";
        Group = "nylon";
        WorkingDirectory = homeDir;
        ExecStart = "${pkgs.nylon}/bin/nylon -f -c ${configFile cfg}";
      };
    };
  };

  anyNylons = collect (p: p ? enable) cfg;
  enabledNylons = filter (p: p.enable == true) anyNylons;
  nylonUnits = map (nylon: mkNamedNylon nylon) enabledNylons;

in

{

  ###### interface

  options = {

    services.nylon = mkOption {
      default = {};
      description = "Collection of named nylon instances";
      type = with types; loaOf (submodule nylonOpts);
      internal = true;
    };

  };

  ###### implementation

  config = mkIf (length(enabledNylons) > 0) {

    users.users.nylon = {
      group = "nylon";
      description = "Nylon SOCKS Proxy";
      home = homeDir;
      createHome = true;
      uid = config.ids.uids.nylon;
    };

    users.groups.nylon.gid = config.ids.gids.nylon;

    systemd.services = fold (a: b: a // b) {} nylonUnits;

  };
}
