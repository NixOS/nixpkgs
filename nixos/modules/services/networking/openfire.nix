{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) jre openfire coreutils which gnugrep gawk gnused;

  extraStartDependency =
    if config.services.openfire.usePostgreSQL then "and started postgresql" else "";

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

  config = mkIf config.services.openfire.enable (
  mkAssert (!(config.services.openfire.usePostgreSQL -> config.services.postgresql.enable)) "
    openfire assertion failed
  " {

    jobs.openfire =
      { description = "OpenFire XMPP server";

        startOn = "started networking ${extraStartDependency}";

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

  });

}
