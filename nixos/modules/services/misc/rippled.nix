# configuration building is commented out until better tested.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.rippled;

  rippledStateCfgFile = "/var/lib/rippled/rippled.cfg";

  rippledCfg = ''
    [node_db]
    type=HyperLevelDB
    path=/var/lib/rippled/db/hyperldb

    [debug_logfile]
    /var/log/rippled/debug.log

  ''
  + optionalString (cfg.peerIp != null) ''
    [peer_ip]
    ${cfg.peerIp}

    [peer_port]
    ${toString cfg.peerPort}

  ''
  + cfg.extraConfig;

  rippledCfgFile = pkgs.writeText "rippled.cfg" rippledCfg;
    
in

{

  ###### interface

  options = {

    services.rippled = {

      enable = mkOption {
        default = false;
	description = "Whether to enable rippled";
      };

      #
      # Rippled has a simple configuration file layout that is easy to 
      # build with nix. Many of the options are defined here but are 
      # commented out until the code to append them to the config above
      # is written and they are tested.
      #
      # If you find a yourself implementing more options, please submit a 
      # pull request.
      #

      /*
      ips = mkOption {
        default = [ "r.ripple.com 51235" ];
	example = [ "192.168.0.1" "192.168.0.1 3939" "r.ripple.com 51235" ];
	description = ''
	  List of hostnames or ips where the Ripple protocol is served.
	  For a starter list, you can either copy entries from: 
	  https://ripple.com/ripple.txt or if you prefer you can let it
	   default to r.ripple.com 51235

	  A port may optionally be specified after adding a space to the 
	  address. By convention, if known, IPs are listed in from most 
	  to least trusted.
	'';
      };

      ipsFixed = mkOption {
        default = null;
	example = [ "192.168.0.1" "192.168.0.1 3939" "r.ripple.com 51235" ];
	description = ''
	  List of IP addresses or hostnames to which rippled should always 
	  attempt to maintain peer connections with. This is useful for 
	  manually forming private networks, for example to configure a 
	  validation server that connects to the Ripple network through a 
	  public-facing server, or for building a set of cluster peers.

	  A port may optionally be specified after adding a space to the address
	'';
      };
      */

      peerIp = mkOption {
        default = null;
	example = "0.0.0.0";
	description = ''
	  IP address or domain to bind to allow external connections from peers.
	  Defaults to not binding, which disallows external connections from peers.
        '';
      };

      peerPort = mkOption {
	default = 51235;
	description = ''
	  If peerIp is supplied, corresponding port to bind to for peer connections.
	'';
      };

      /*
      peerPortProxy = mkOption {
        type = types.int;
	example = 51236;
	description = ''
	  An optional, additional listening port number for peers. Incoming
	  connections on this port will be required to provide a PROXY Protocol
	  handshake, described in this document (external link):

	    http://haproxy.1wt.eu/download/1.5/doc/proxy-protocol.txt

	  The PROXY Protocol is a popular method used by elastic load balancing
	  service providers such as Amazon, to identify the true IP address and
	  port number of external incoming connections.

	  In addition to enabling this setting, it will also be required to
	  use your provider-specific control panel or administrative web page
	  to configure your server instance to receive PROXY Protocol handshakes,
	  and also to restrict access to your instance to the Elastic Load Balancer.
	'';
      };

      peerPrivate = mkOption {
        default = null;
	example = 0;
	description = ''
	 0: Request peers to broadcast your address. Normal outbound peer connections [default]
	 1: Request peers not broadcast your address. Only connect to configured peers.
       '';
     };

     peerSslCipherList = mkOption {
       default = null;
       example = "ALL:!LOW:!EXP:!MD5:@STRENGTH";
       description = ''
         A colon delimited string with the allowed SSL cipher modes for peer. The
	 choices for for ciphers are defined by the OpenSSL API function
	 SSL_CTX_set_cipher_list, documented here (external link):

	  http://pic.dhe.ibm.com/infocenter/tpfhelp/current/index.jsp?topic=%2Fcom.ibm.ztpf-ztpfdf.doc_put.cur%2Fgtpc2%2Fcpp_ssl_ctx_set_cipher_list.html

	The default setting of "ALL:!LOW:!EXP:!MD5:@STRENGTH", which allows
	non-authenticated peer connections (they are, however, secure).
      '';
    };

    nodeSeed = mkOption {
      default = null;
      example = "RASH BUSH MILK LOOK BAD BRIM AVID GAFF BAIT ROT POD LOVE";
      description = ''
        This is used for clustering. To force a particular node seed or key, the
	key can be set here.  The format is the same as the validation_seed field.
	To obtain a validation seed, use the rippled validation_create command.
      '';
    };

    clusterNodes = mkOption {
      default = null;
      example = [ "n9KorY8QtTdRx7TVDpwnG9NvyxsDwHUKUEeDLY3AkiGncVaSXZi5" ];
      description = ''
        To extend full trust to other nodes, place their node public keys here.
	Generally, you should only do this for nodes under common administration.
	Node public keys start with an 'n'. To give a node a name for identification
	place a space after the public key and then the name.
      '';
    };

    sntpServers = mkOption {
      default = null;
      example = [ "time.nist.gov" "pool.ntp.org" ];
      description = ''
        IP address or domain of NTP servers to use for time synchronization.
      '';
    };

    # TODO: websocket options

    rpcAllowRemote = mkOption {
      default = false;
      description = ''
        false: Allow RPC connections only from 127.0.0.1. [default]
	true:  Allow RPC connections from any IP.
      '';
    };

    rpcAdminAllow = mkOption {
      example = [ "10.0.0.4" ];
      description = ''
        List of IP addresses allowed to have admin access.
      '';
    };

    rpcAdminUser = mkOption {
      type = types.str;
      description = ''
        As a server, require this as the admin user to be specified.  Also, require
	rpc_admin_user and rpc_admin_password to be checked for RPC admin functions.
	The request must specify these as the admin_user and admin_password in the
	request object.
      '';
    };

    rpcAdminPassword = mkOption {
      type = types.str;
      description = ''
        As a server, require this as the admin pasword to be specified.  Also,
	require rpc_admin_user and rpc_admin_password to be checked for RPC admin
	functions.  The request must specify these as the admin_user and
	admin_password in the request object.
      '';
    };

      rpcIp = mkOption {
        type = types.str;
	description = ''
	  IP address or domain to bind to allow insecure RPC connections.
	  Defaults to not binding, which disallows RPC connections.
	'';
      };

      rpcPort = mkOption {
        type = types.int;
        description = ''
          If rpcIp is supplied, corresponding port to bind to for peer connections.
        '';
      };

      rpcUser = mkOption {
        type = types.str;
	description = ''
	  Require a this user to specified and require rpcPassword to
	  be checked for RPC access via the rpcIp and rpcPort. The user and password
	  must be specified via HTTP's basic authentication method.
	  As a client, supply this to the server via HTTP's basic authentication
	  method.
	'';
      };

      rpcPassword = mkOption {
        type = types.str;
	description = ''
	  Require a this password to specified and require rpc_user to
	  be checked for RPC access via the rpcIp and rpcPort. The user and password
	  must be specified via HTTP's basic authentication method.
	  As a client, supply this to the server via HTTP's basic authentication
	  method.
	'';
      };

      rpcStartup = mkOption {
        example = [ ''"command" : "log_level"'' ''"partition" : "ripplecalc"'' ''"severity" : "trace"'' ];
	description = "List of RPC commands to run at startup.";
      };

      rpcSecure = mkOption {
        default = false;
	description = ''
	  false: Server certificates are not provided for RPC clients using SSL [default]
	  true:  Client RPC connections wil be provided with SSL certificates.

	  Note that if rpc_secure is enabled, it will also be necessasry to configure the
	  certificate file settings located in rpcSslCert, rpcSslChain, and rpcSslKey
	'';
      };
      */

      extraConfig = mkOption {
        default = "";
	description = ''
	  Extra lines to be added verbatim to the rippled.cfg configuration file.
	'';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = "rippled";
        description = "Ripple server user";
        uid = config.ids.uids.rippled;
	home = "/var/lib/rippled";
      };

    systemd.services.rippled = {
      path = [ pkgs.rippled ];

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.rippled}/bin/rippled --fg -q --conf ${rippledStateCfgFile}";
	WorkingDirectory = "/var/lib/rippled";
      };
    };

    networking.firewall.allowedTCPPorts = mkIf (cfg.peerIp != null) [ cfg.peerPort ];

    system.activationScripts.rippled = ''
      mkdir -p /var/{lib,log}/rippled
      chown -R rippled /var/{lib,log}/rippled
      ln -sf ${rippledCfgFile} ${rippledStateCfgFile}
    '';
  };
}
