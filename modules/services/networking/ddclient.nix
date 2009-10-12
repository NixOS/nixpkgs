{ config, pkgs, ... }:

let

  inherit (pkgs.lib) mkOption mkIf singleton;

  inherit (pkgs) ddclient;

  stateDir = "/var/spool/ddclient";

  ddclientUser = "ddclient";

  modprobe = config.system.sbin.modprobe;

  ddclientFlags = "-foreground -file ${ddclientCfg}";

  ddclientCfg = pkgs.writeText "ddclient.conf" ''
    daemon=600
    cache=${stateDir}/ddclient.cache
    pid=${stateDir}/ddclient.pid
    use=${config.services.ddclient.web}
    login=${config.services.ddclient.username}
    password=${config.services.ddclient.password}
    protocol=${config.services.ddclient.protocol}
    server=${config.services.ddclient.server}
    wildcard=YES
    ${config.services.ddclient.domain}
    ${config.services.ddclient.extraConfig}
  '';

in

{

  ###### interface
  
  options = {
  
    services.ddclient = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to synchronise your machine's IP address with a dynamic DNS provider (e.g. dyndns.org).
        '';
      };

      domain = mkOption {
        default = "";
        description = ''
          Domain name to synchronize.
        '';
      };

      username = mkOption {
        default = "";
        description = ''
          Username.
        '';
      };

      password = mkOption {
        default = "" ;
        description = ''
          Password.
        '';
      };

      protocol = mkOption {
        default = "dyndns2" ;
        description = ''
          Protocol to use with dynamic DNS provider. (see also, http://sourceforge.net/apps/trac/ddclient/wiki/Protocols)
        '';
      };

      server = mkOption {
        default = "members.dyndns.org" ;
        description = ''
          Server
        '';
      };

      extraConfig = mkOption {
        default = "" ;
        description = ''
          Extra configuration. Contents will be added verbatim to the configuration file.
        '';
      };

      web = mkOption {
        default = "web, web=checkip.dyndns.com/, web-skip='IP Address'" ;
        description = ''
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.ddclient.enable {
    environment.systemPackages = [ ddclient ];
  
    users.extraUsers = singleton
      { name = ddclientUser;
        uid = config.ids.uids.ddclient;
        description = "ddclient daemon user";
        home = stateDir;
      };

    jobAttrs.ddclient =
      { name = "ddclient";

        startOn = "startup";
        stopOn = "shutdown"; 

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
            chown ${ddclientUser} ${stateDir}

            # Needed to run ddclient as an unprivileged user.
            ${modprobe}/sbin/modprobe capability || true
          '';

        exec = "${ddclient}/bin/ddclient ${ddclientFlags}";
      };

  };
  
}
