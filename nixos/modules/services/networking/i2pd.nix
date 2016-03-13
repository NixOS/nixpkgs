{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.i2pd;

  homeDir = "/var/lib/i2pd";

  extip = "EXTIP=\$(${pkgs.curl}/bin/curl -sf \"http://jsonip.com\" | ${pkgs.gawk}/bin/awk -F'\"' '{print $4}')";

  toYesNo = b: if b then "yes" else "no";

  mkEndpointOpt = name: addr: port: {
    enable = mkEnableOption name;
    name = mkOption {
      type = types.str;
      default = name;
      description = "The endpoint name.";
    };
    address = mkOption {
      type = types.str;
      default = addr;
      description = "Bind address for ${name} endpoint. Default: " + addr;
    };
    port = mkOption {
      type = types.int;
      default = port;
      description = "Bind port for ${name} endoint. Default: " + toString port;
    };
  };

  commonTunOpts = let
    i2cpOpts = {
      length = mkOption {
        type = types.int;
        description = "Guaranteed minimum hops.";
        default = 3;
      };
      quantity = mkOption {
        type = types.int;
        description = "Number of simultaneous tunnels.";
        default = 5;
      };
    };
  in name: {
    outbound = i2cpOpts;
    inbound = i2cpOpts;
    crypto.tagsToSend = mkOption {
      type = types.int;
      description = "Number of ElGamal/AES tags to send.";
      default = 40;
    };
   destination = mkOption {
      type = types.str;
      description = "Remote endpoint, I2P hostname or b32.i2p address.";
    };
    keys = mkOption {
      type = types.str;
      default = name + "-keys.dat";
      description = "Keyset used for tunnel identity.";
    };
  } // mkEndpointOpt name "127.0.0.1" 0;

  i2pdConf = pkgs.writeText "i2pd.conf" ''
      ipv6 = ${toYesNo cfg.enableIPv6}
      notransit = ${toYesNo cfg.notransit}
      floodfill = ${toYesNo cfg.floodfill}
      ${if isNull cfg.port then "" else "port = ${toString cfg.port}"}
      ${flip concatMapStrings
        (collect (proto: proto ? port && proto ? address && proto ? name) cfg.proto)
        (proto: let portStr = toString proto.port; in ''
      [${proto.name}]
      address = ${proto.address}
      port = ${toString proto.port}
      enabled = ${toYesNo proto.enable}
      '')
      }
  '';

  i2pdTunnelConf = pkgs.writeText "i2pd-tunnels.conf" ''
  ${flip concatMapStrings
    (collect (tun: tun ? port && tun ? destination) cfg.outTunnels)
    (tun: let portStr = toString tun.port; in ''
  [${tun.name}]
  type = client
  destination = ${tun.destination}
  keys = ${tun.keys}
  address = ${tun.address}
  port = ${toString tun.port}
  inbound.length = ${toString tun.inbound.length}
  outbound.length = ${toString tun.outbound.length}
  inbound.quantity = ${toString tun.inbound.quantity}
  outbound.quantity = ${toString tun.outbound.quantity}
  crypto.tagsToSend = ${toString tun.crypto.tagsToSend}
  '')
  }
  ${flip concatMapStrings
    (collect (tun: tun ? port && tun ? host) cfg.inTunnels)
    (tun: let portStr = toString tun.port; in ''
  [${tun.name}]
  type = server
  destination = ${tun.destination}
  keys = ${tun.keys}
  host = ${tun.address}
  port = ${tun.port}
  inport = ${tun.inPort}
  accesslist = ${concatStringSep "," tun.accessList}
  '')
  }
  '';

  i2pdSh = pkgs.writeScriptBin "i2pd" ''
    #!/bin/sh
    ${if isNull cfg.extIp then extip else ""}
    ${pkgs.i2pd}/bin/i2pd --log=1 \
      --host=${if isNull cfg.extIp then "$EXTIP" else cfg.extIp} \
      --conf=${i2pdConf} \
      --tunconf=${i2pdTunnelConf}
  '';

in

{

  ###### interface

  options = {

    services.i2pd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables I2Pd as a running service upon activation.
        '';
      };

      extIp = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          Your external IP.
        '';
      };

      notransit = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Tells the router to not accept transit tunnels during startup.
        '';
      };

      floodfill = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If the router is declared to be unreachable and needs introduction nodes.
        '';
      };

      port = mkOption {
        type = with types; nullOr int;
        default = null;
        description = ''
          I2P listen port. If no one is given the router will pick between 9111 and 30777.
        '';
      };

      enableIPv6 = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enables IPv6 connectivity. Disabled by default.
        '';
      };

      proto.http = mkEndpointOpt "http" "127.0.0.1" 7070;
      proto.sam = mkEndpointOpt "sam" "127.0.0.1" 7656;
      proto.bob = mkEndpointOpt "bob" "127.0.0.1" 2827;
      proto.i2pControl = mkEndpointOpt "i2pcontrol" "127.0.0.1" 7650;
      proto.httpProxy = mkEndpointOpt "httpproxy" "127.0.0.1" 4446;
      proto.socksProxy = mkEndpointOpt "socksproxy" "127.0.0.1" 4447;

      outTunnels = mkOption {
        default = {};
        type = with types; loaOf optionSet;
        description = ''
          Connect to someone as a client and establish a local accept endpoint
        '';
        options = [ ({ name, config, ... }: {
          options = commonTunOpts name;
          config = {
            name = mkDefault name;
          };
        }) ];
      };

      inTunnels = mkOption {
        default = {};
        type = with types; loaOf optionSet;
        description = ''
          Serve something on I2P network at port and delegate requests to address inPort.
        '';
        options = [ ({ name, config, ... }: {

          options = {
            inPort = mkOption {
              type = types.int;
              default = 0;
              description = "Service port. Default to the tunnel's listen port.";
            };
            accessList = mkOption {
              type = with types; listOf str;
              default = [];
              description = "I2P nodes that are allowed to connect to this service.";
            };
          } // commonTunOpts name;

          config = {
            name = mkDefault name;
          };

        }) ];
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers.i2pd = {
      group = "i2pd";
      description = "I2Pd User";
      home = homeDir;
      createHome = true;
      uid = config.ids.uids.i2pd;
    };

    users.extraGroups.i2pd.gid = config.ids.gids.i2pd;

    systemd.services.i2pd = {
      description = "Minimal I2P router";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig =
      {
        User = "i2pd";
        WorkingDirectory = homeDir;
        Restart = "on-abort";
        ExecStart = "${i2pdSh}/bin/i2pd";
      };
    };
  };
}
