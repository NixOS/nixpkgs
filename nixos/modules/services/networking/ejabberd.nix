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

      loadDumps = mkOption {
        default = [];
        description = "Configuration dump that should be loaded on the first startup";
        example = [ ./myejabberd.dump ];
      };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.ejabberd ];

    jobs.ejabberd =
      { description = "EJabberd server";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        environment = {
          PATH = "$PATH:${pkgs.ejabberd}/sbin:${pkgs.ejabberd}/bin:${pkgs.coreutils}/bin:${pkgs.bash}/bin:${pkgs.gnused}/bin";
        };

        preStart =
          ''
            # Initialise state data
            mkdir -p ${cfg.logsDir}

            if ! test -d ${cfg.spoolDir}
            then
                initialize=1
                cp -av ${pkgs.ejabberd}/var/lib/ejabberd /var/lib
            fi

            if ! test -d ${cfg.confDir}
            then
                mkdir -p ${cfg.confDir}
                cp ${pkgs.ejabberd}/etc/ejabberd/* ${cfg.confDir}
                sed -e 's|{hosts, \["localhost"\]}.|{hosts, \[${cfg.virtualHosts}\]}.|' ${pkgs.ejabberd}/etc/ejabberd/ejabberd.cfg > ${cfg.confDir}/ejabberd.cfg
            fi

            ejabberdctl --config-dir ${cfg.confDir} --logs ${cfg.logsDir} --spool ${cfg.spoolDir} start

            ${if cfg.loadDumps == [] then "" else
              ''
                if [ "$initialize" = "1" ]
                then
                    # Wait until the ejabberd server is available for use
                    count=0
                    while ! ejabberdctl --config-dir ${cfg.confDir} --logs ${cfg.logsDir} --spool ${cfg.spoolDir} status
                    do
                        if [ $count -eq 30 ]
                        then
                            echo "Tried 30 times, giving up..."
                            exit 1
                        fi

                        echo "Ejabberd daemon not yet started. Waiting for 1 second..."
                        count=$((count++))
                        sleep 1
                    done

                    ${concatMapStrings (dump:
                      ''
                        echo "Importing dump: ${dump}"

                        if [ -f ${dump} ]
                        then
                            ejabberdctl --config-dir ${cfg.confDir} --logs ${cfg.logsDir} --spool ${cfg.spoolDir} load ${dump}
                        elif [ -d ${dump} ]
                        then
                            for i in ${dump}/ejabberd-dump/*
                            do
                                ejabberdctl --config-dir ${cfg.confDir} --logs ${cfg.logsDir} --spool ${cfg.spoolDir} load $i
                            done
                        fi
                      '') cfg.loadDumps}
                fi
              ''}
          '';

        postStop =
          ''
            ejabberdctl --config-dir ${cfg.confDir} --logs ${cfg.logsDir} --spool ${cfg.spoolDir} stop
          '';
      };

  };

}
