{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf singleton concatStrings;
  inherit (pkgs) sitecopy;

  stateDir = "/var/spool/sitecopy";

  sitecopyCron = backup : ''
    ${if backup ? period then backup.period else config.services.sitecopy.period} root ${sitecopy}/bin/sitecopy --storepath=${stateDir} --rcfile=${stateDir}/${backup.name}.conf --update ${backup.name}
  ''; 
in

{

  options = {
  
    services.sitecopy = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable sitecopy backups of specified directories.
        '';
      };

      period = mkOption {
        default = "15 04 * * *";
        description = ''
          This option defines (in the format used by cron) when the
          sitecopy backup are being run.
          The default is to update at 04:15 (at night) every day.
        '';
      };

      backups = mkOption {
        example = [
          { name = "test"; 
            local = "/tmp/backup"; 
            remote = "/staff-groups/ewi/st/strategoxt/backup/test";
            server = "webdata.tudelft.nl";
            protocol = "webdav";
            https = true ;
          }
        ];
        default = [];
        description = ''
           List of attributesets describing the backups. 

           Username/password are extracted from <filename>${stateDir}/sitecopy.secrets</filename> at activation 
           time. The secrets file lines should have the following structure:
           <screen>
             server username password
           </screen>
        '';
      }; 

    };

  };

  config = mkIf config.services.sitecopy.enable {
    environment.systemPackages = [ sitecopy ];

    services.cron = {
      systemCronJobs = map sitecopyCron config.services.sitecopy.backups;
    };


    system.activationScripts.sitecopyBackup = 
      pkgs.stringsWithDeps.noDepEntry ''  
          mkdir -m 0700 -p ${stateDir}
          chown root ${stateDir}
          touch ${stateDir}/sitecopy.secrets
          chown root ${stateDir}/sitecopy.secrets

          ${pkgs.lib.concatStrings (map ( b: ''
              unset secrets
              unset secret
              secrets=`grep '^${b.server}' ${stateDir}/sitecopy.secrets | head -1`
              secret=($secrets)
              cat > ${stateDir}/${b.name}.conf << EOF
                site ${b.name}
                server ${b.server}
                protocol ${b.protocol}
                username ''${secret[1]}
                password ''${secret[2]}
                local ${b.local}
                remote ${b.remote}
                ${if b.https then "http secure" else ""}
              EOF
              chmod 0600 ${stateDir}/${b.name}.conf
              if ! test -e ${stateDir}/${b.name} ; then
                echo " * Initializing sitecopy '${b.name}'"
                ${sitecopy}/bin/sitecopy --storepath=${stateDir} --rcfile=${stateDir}/${b.name}.conf --initialize ${b.name}
              else
                echo " * Sitecopy '${b.name}' already initialized"
              fi
            '' ) config.services.sitecopy.backups 
         )}

      '';
  };
  
}
