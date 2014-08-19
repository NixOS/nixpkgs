# You may notice the commented out sections in this file,
# it would be great to configure cjdns from nix, but cjdns 
# reads its configuration from stdin, including the private
# key and admin password, all nested in a JSON structure.
#
# Until a good method of storing the keys outside the nix 
# store and mixing them back into a string is devised
# (without too much shell hackery), a skeleton of the
# configuration building lies commented out.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.cjdns;

  /*
  # can't keep keys and passwords in the nix store,
  # but don't want to deal with this stdin quagmire.

  cjdrouteConf = '' {
    "admin": {"bind": "${cfg.admin.bind}", "password": "\${CJDNS_ADMIN}" },
    "privateKey": "\${CJDNS_KEY}",

    "interfaces": {
    ''

    + optionalString (cfg.interfaces.udp.bind.address != null) ''
      "UDPInterface": [ {
        "bind": "${cfg.interfaces.udp.bind.address}:"''
	   ${if cfg.interfaces.upd.bind.port != null
             then ${toString cfg.interfaces.udp.bind.port}
	     else ${RANDOM}
	   fi)
      + '' } ]''

    + (if cfg.interfaces.eth.bind != null then ''
      "ETHInterface": [ {
        "bind": "${cfg.interfaces.eth.bind}",
        "beacon": ${toString cfg.interfaces.eth.beacon}
      } ]
    '' fi )
    + ''
    },
    "router": { "interface": { "type": "TUNInterface" }, },
    "security": [ { "setuser": "nobody" } ]
    }
    '';   

    cjdrouteConfFile = pkgs.writeText "cjdroute.conf" cjdrouteConf
    */
in

{
  options = {

    services.cjdns = {

      enable = mkOption {
        type = types.bool;
	default = false;
        description = ''
          Enable this option to start a instance of the 
          cjdns network encryption and and routing engine.
          Configuration will be read from <literal>confFile</literal>.
        '';
      };

      confFile = mkOption {
	default = "/etc/cjdroute.conf";
        description = ''
          Configuration file to pipe to cjdroute.
        '';
      };

      /*
      admin = {
        bind = mkOption {
	  default = "127.0.0.1:11234";
	  description = ''
            Bind the administration port to this address and port.
	  '';
        };

	passwordFile = mkOption {
	  example = "/root/cjdns.adminPassword";
	  description = ''
	    File containing a password to the administration port.
	  '';
	};
      };

      keyFile = mkOption {
        type = types.str;
	example = "/root/cjdns.key";
	description = ''
	  Path to a file containing a cjdns private key on a single line.
	'';
      };
      
      passwordsFile = mkOption {
        type = types.str;
	default = null;
	example = "/root/cjdns.authorizedPasswords";
	description = ''
	  A file containing a list of json dictionaries with passwords.
	  For example:
	    {"password": "s8xf5z7znl4jt05g922n3wpk75wkypk"},
	    { "name": "nice guy",
	      "password": "xhthk1mglz8tpjrbbvdlhyc092rhpx5"},
	    {"password": "3qfxyhmrht7uwzq29pmhbdm9w4bnc8w"}
	  '';
	};

      interfaces = {
        udp = {
	  bind = { 
            address = mkOption {
	      default = "0.0.0.0";
	      description = ''
	        Address to bind UDP tunnels to; disable by setting to null;
	      '';
 	    };
	    port = mkOption {
	      type = types.int;
	      default = null;
	      description = ''
	        Port to bind UDP tunnels to.
	        A port will be choosen at random if this is not set.
	        This option is required to act as the server end of 
	        a tunnel.
	      '';
 	    };
	  };
	};

	eth = {
	  bind = mkOption {
	    default = null;
	    example = "eth0";
	    description = ''
	      Bind to this device and operate with native wire format.
	    '';
	  };

	  beacon = mkOption {
	    default = 2;
	    description = ''
	      Auto-connect to other cjdns nodes on the same network.
	      Options:
	        0 -- Disabled.

                1 -- Accept beacons, this will cause cjdns to accept incoming
		     beacon messages and try connecting to the sender.

		2 -- Accept and send beacons, this will cause cjdns to broadcast
		     messages on the local network which contain a randomly
		     generated per-session password, other nodes which have this
                     set to 1 or 2 will hear the beacon messages and connect
                     automatically.
            '';
	  };
	  
	  connectTo = mkOption {
	    type = types.listOf types.str;
	    default = [];
	    description = ''
	      Credentials for connecting look similar to UDP credientials
              except they begin with the mac address, for example:
              "01:02:03:04:05:06":{"password":"a","publicKey":"b"}
	    '';
	  };
        };
      };
      */
    };
  };

  config = mkIf config.services.cjdns.enable {

    boot.kernelModules = [ "tun" ];

    /*
    networking.firewall.allowedUDPPorts = mkIf (cfg.udp.bind.port != null) [
      cfg.udp.bind.port
    ];
    */

    systemd.services.cjdns = {
      description = "encrypted networking for everybody";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network.target" ];
      before = [ "network.target" ];
      path = [ pkgs.cjdns ];

      serviceConfig = {
        Type = "forking";
	ExecStart = ''
          ${pkgs.stdenv.shell} -c "${pkgs.cjdns}/sbin/cjdroute < ${cfg.confFile}"
	'';
	Restart = "on-failure";
      };
    };
  };
}
