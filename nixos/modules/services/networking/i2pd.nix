{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.i2pd;

  homeDir = "/var/lib/i2pd";

  extip = "EXTIP=\$(${pkgs.curl}/bin/curl -sf \"http://jsonip.com\" | ${pkgs.gawk}/bin/awk -F'\"' '{print $4}')";

  toOneZero = b: if b then "1" else "0";

  i2pdConf = pkgs.writeText "i2pd.conf" ''
      v6 = ${toOneZero cfg.enableIPv6}
      unreachable = ${toOneZero cfg.unreachable}
      floodfill = ${toOneZero cfg.floodfill}
      ${if isNull cfg.port then "" else "port = ${toString cfg.port}"}
      httpproxyport = ${toString cfg.proxy.httpPort}
      socksproxyport = ${toString cfg.proxy.socksPort}
      ircaddress = ${cfg.irc.host}
      ircport = ${toString cfg.irc.port}
      ircdest = ${cfg.irc.dest}
      irckeys = ${cfg.irc.keyFile}
      eepport = ${toString cfg.eep.port}
      ${if isNull cfg.sam.port then "" else "--samport=${toString cfg.sam.port}"}
      eephost = ${cfg.eep.host}
      eepkeys = ${cfg.eep.keyFile}
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
  '')
  }
  ${flip concatMapStrings
    (collect (tun: tun ? port && tun ? host) cfg.outTunnels)
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
    ${pkgs.i2pd}/bin/i2pd --log=1 --daemon=0 --service=0 \
      --host=${if isNull cfg.extIp then "$EXTIP" else cfg.extIp} \
      --conf=${i2pdConf} \
      --tunnelscfg=${i2pdTunnelConf}
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

      unreachable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          If the router is declared to be unreachable and needs introduction nodes.
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

      http = {
        port = mkOption {
          type = types.int;
          default = 7070;
          description = ''
            HTTP listen port.
          '';
        };
      };

      proxy = {
        httpPort = mkOption {
          type = types.int;
          default = 4446;
          description = ''
            HTTP proxy listen port.
          '';
        };
        socksPort = mkOption {
          type = types.int;
          default = 4447;
          description = ''
            SOCKS proxy listen port.
          '';
        };
      };

      irc = {
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Address to forward incoming traffic to. 127.0.0.1 by default.
          '';
        };
        dest = mkOption {
          type = types.str;
          default = "irc.postman.i2p";
          description = ''
            Destination I2P tunnel endpoint address of IRC server. irc.postman.i2p by default.
          '';
        };
        port = mkOption {
          type = types.int;
          default = 6668;
          description = ''
            Local IRC tunnel endoint port to listen on. 6668 by default.
          '';
        };
        keyFile = mkOption {
          type = types.str;
          default = "privKeys.dat";
          description = ''
            File name containing destination keys. privKeys.dat by default.
          '';
        };
      };

      eep = {
        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = ''
            Address to forward incoming traffic to. 127.0.0.1 by default.
          '';
        };
        port = mkOption {
          type = types.int;
          default = 80;
          description = ''
            Port to forward incoming traffic to. 80 by default.
          '';
        };
        keyFile = mkOption {
          type = types.str;
          default = "privKeys.dat";
          description = ''
            File name containing destination keys. privKeys.dat by default.
          '';
        };
      };

      sam = {
        port = mkOption {
          type = with types; nullOr int;
          default = null;
          description = ''
            Local SAM tunnel endpoint. Usually 7656. SAM is disabled if not specified.
          '';
        };
      };

      outTunnels = mkOption {
        default = {};
	      type = with types; loaOf optionSet;
	      description = ''
	      '';
	      options = [ ({ name, config, ... }: {

	        options = {
	          name = mkOption {
	            type = types.str;
	            description = "The name of the tunnel.";
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
	          address = mkOption {
	            type = types.str;
	            default = "127.0.0.1";
	            description = "Local bind address for tunnel.";
	          };
	          port = mkOption {
	            type = types.int;
	            default = 0;
	            description = "Local tunnel listen port.";
	          };
	        };

	        config = {
	          name = mkDefault name;
	        };

	      }) ];
      };

      inTunnels = mkOption {
        default = {};
	      type = with types; loaOf optionSet;
	      description = ''
	      '';
	      options = [ ({ name, config, ... }: {

	        options = {

	          name = mkOption {
	            type = types.str;
	            description = "The name of the tunnel.";
	          };
	          keys = mkOption {
	            type = types.path;
	            default = name + "-keys.dat";
	            description = "Keyset used for tunnel identity.";
	          };
	          address = mkOption {
	            type = types.str;
	            default = "127.0.0.1";
	            description = "Local service IP address.";
	          };
	          port = mkOption {
	            type = types.int;
	            default = 0;
	            description = "Local tunnel listen port.";
	          };
	          inPort = mkOption {
	            type = types.int;
	            default = 0;
	            description = "I2P service port. Default to the tunnel's listen port.";
	          };
	          accessList = mkOption {
	            type = with types; listOf str;
	            default = [];
	            description = "I2P nodes that are allowed to connect to this service.";
	          };

	        };

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
