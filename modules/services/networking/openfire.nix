{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) jre openfire coreutils which gnugrep gawk gnused;
    
  startDependency =
    if config.services.openfire.usePostgreSQL then "postgresql" else
    if config.services.gw6c.enable then "gw6c" else
    "network-interfaces";
    
in

{

  ###### interface

  options = {
  
    services.openfire = {
    
      enable = mkOption {
        default = false;
        description = "
          Whether to enable OpenFire XMPP server.
        ";
      };
      
      usePostgreSQL = mkOption {
        default = true;
        description = "
          Whether you use PostgreSQL service for your storage back-end.
        ";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.openfire.enable {

    assertions = singleton
      { assertion = !(config.services.openfire.usePostgreSQL -> config.services.postgresql.enable);
        message = "openfire assertion failed";
      };

    jobAttrs.openfire =
      { description = "OpenFire XMPP server";

        startOn = "${startDependency}/started";
        stopOn = "shutdown";

        script =
          ''
            export PATH=${jre}/bin:${openfire}/bin:${coreutils}/bin:${which}/bin:${gnugrep}/bin:${gawk}/bin:${gnused}/bin
            export HOME=/tmp
            mkdir /var/log/openfire || true 
            mkdir /etc/openfire || true 
            for i in ${openfire}/conf.inst/*; do
                if ! test -f /etc/openfire/$(basename $i); then
                    cp $i /etc/openfire/
                fi
            done
            openfire start
          ''; # */
      };

  };
  
}
