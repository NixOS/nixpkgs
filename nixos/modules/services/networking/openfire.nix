{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {

    services.openfire = {

      enable = mkEnableOption "OpenFire XMPP server";

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
        message = "OpenFire configured to use PostgreSQL but services.postgresql.enable is not enabled.";
      };

    systemd.services.openfire = {
      description = "OpenFire XMPP server";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ] ++
        optional config.services.openfire.usePostgreSQL "postgresql.service";
      path = with pkgs; [ jre openfire coreutils which gnugrep gawk gnused ];
      script = ''
        export HOME=/tmp
        mkdir /var/log/openfire || true
        mkdir /etc/openfire || true
        for i in ${pkgs.openfire}/conf.inst/*; do
            if ! test -f /etc/openfire/$(basename $i); then
                cp $i /etc/openfire/
            fi
        done
        openfire start
      ''; # */
    };
  };

}
