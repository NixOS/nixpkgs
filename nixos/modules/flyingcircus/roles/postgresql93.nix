{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.flyingcircus;

  min = list:
    builtins.head (builtins.sort builtins.lessThan list);
  max = list:
    lib.last (builtins.sort builtins.lessThan list);


  # return the "current" system memory in MiB. We currently use the value from
  # the ENC but should use the actual system memory.
  current_memory =
    if lib.hasAttrByPath ["parameters" "memory"] cfg.enc
    then cfg.enc.parameters.memory
    else 256;

  shared_memory_max = current_memory / 2 * 1048576;

  shared_buffers =
    min [
      (max [16 (current_memory / 4)])
       (shared_memory_max * 4 / 5)];

  wal_buffers =
    max [
      (min [64 (shared_buffers / 32)])
      1];
in
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

    # System tweaks
    boot.kernel.sysctl = {
      "kernel.shmmax" = toString shared_memory_max;
      "kernel.shmall" = toString (shared_memory_max / 4096);
    };


    # Custom postgresql configuration
    services.postgresql.extraConfig = ''
      #------------------------------------------------------------------------------
      # WRITE AHEAD LOG
      #------------------------------------------------------------------------------
      wal_level = hot_standby
      wal_buffers = ${toString wal_buffers}MB
      checkpoint_segments = 100
      checkpoint_completion_target = 0.9
      archive_mode = on
      archive_command = '/usr/local/sbin/postgresql-archive-log %p'
      archive_timeout = 60

    '';
  };

}
