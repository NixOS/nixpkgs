{ config, lib, pkgs, ... }: with lib;

{
  options = {

    flyingcircus.roles.postgresql93 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Flying Circus PostgreSQL server role.";
      };
    };

  };

  config = mkIf config.flyingcircus.roles.postgresql93.enable {

    services.postgresql.enable = true;
    services.postgresql.package = pkgs.postgresql93;

    services.postgresql.initialScript = ./postgresql-init.sql;
    services.postgresql.dataDir = "/srv/postgresql/9.3";

    users.users.postgres = {
      shell = "/run/current-system/sw/bin/bash";
      home = "/srv/postgresql";
    };
    system.activationScripts.flyingcircus_postgresql93 = ''
      if ! test -e /srv/postgresql; then
        mkdir -p /srv/postgresql
      fi
      chown ${toString config.ids.uids.postgres} /srv/postgresql
    '';
    security.sudo.extraConfig = ''
      # Service users may switch to the postgres system user
      %sudo-srv ALL=(postgres) ALL
      %service ALL=(postgres) ALL
    '';

  };

}
