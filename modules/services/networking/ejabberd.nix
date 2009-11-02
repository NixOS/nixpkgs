{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.ejabberd;

in

{

  ###### interface

  options = {
  
    services.ejabberd = {
    
      enable = mkOption {
        default = false;
        description = "Whether to enable ejabberd server";
      };

      spoolDir = mkOption {
        default = "/var/lib/ejabberd";
        description = "Location of the spooldir of ejabberd";
      };

      logsDir = mkOption {
        default = "/var/log/ejabberd";
        description = "Location of the logfile directory of ejabberd";
      };

      confDir = mkOption {
        default = "/var/ejabberd";
        description = "Location of the config directory of ejabberd";
      };

      virtualHosts = mkOption {
        default = "\"localhost\"";
        description = "Virtualhosts that ejabberd should host. Hostnames are surrounded with doublequotes and separated by commas";
      };

    };
    
  };
  

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ejabberd ];

    jobs.ejabberd =
      { description = "EJabberd server";

        startOn = "network-interface/started";
        stopOn = "network-interfaces/stop";

        preStart =
          ''
            # Initialise state data
            mkdir -p ${cfg.logsDir}

            if ! test -d ${cfg.spoolDir}
            then
                cp -av ${pkgs.ejabberd}/var/lib/ejabberd /var/lib
            fi
            
            if ! test -d ${cfg.confDir}
	    then
		mkdir -p ${cfg.confDir}
	        cp ${pkgs.ejabberd}/etc/ejabberd/* ${cfg.confDir}
	        sed -e 's|{hosts, \["localhost"\]}.|{hosts, \[${cfg.virtualHosts}\]}.|' ${pkgs.ejabberd}/etc/ejabberd/ejabberd.cfg > ${cfg.confDir}/ejabberd.cfg
	    fi
          '';

        exec = "${pkgs.bash}/bin/sh -c 'export PATH=$PATH:${pkgs.ejabberd}/sbin:${pkgs.coreutils}/bin:${pkgs.bash}/bin; ejabberdctl --config-dir ${cfg.confDir} --logs ${cfg.logsDir} --spool ${cfg.spoolDir} start; sleep 1d'";

        postStop =
          ''        
            ${pkgs.ejabberd}/sbin/ejabberdctl stop
          '';
      };

  };
  
}
