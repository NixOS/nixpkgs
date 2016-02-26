{ config, lib, pkgs, ... }: with lib;

let
  cfg = config.flyingcircus;

  # This looks clunky.
  version =
      if cfg.roles.postgresql94.enable
      then "9.4"
      else if cfg.roles.postgresql93.enable
      then "9.3"
      else null;


  # Is *any* postgres role enabled?
  postgres_enabled = version != null;

  package = {
    "9.3" = pkgs.postgresql93;
    "9.4" = pkgs.postgresql94;
  };

  min = list:
    builtins.head (builtins.sort builtins.lessThan list);
  max = list:
    lib.last (builtins.sort builtins.lessThan list);

  current_memory =
    let
      enc_memory =
        if lib.hasAttrByPath ["parameters" "memory"] cfg.enc
        then cfg.enc.parameters.memory
        else null;
      system_memory =
        if hasAttr "memory" cfg.system_state
        then cfg.system_state.memory
        else null;
      options = lib.remove null [enc_memory system_memory];
    in
      if options == []
      then 256
      else min options;

  shared_memory_max = current_memory / 2 * 1048576;

  shared_buffers =
    min [
      (max [16 (current_memory / 4)])
       (shared_memory_max * 4 / 5)];

  work_mem =
    max [1 shared_buffers 200];

  maintenance_work_mem =
    max [16 work_mem (current_memory / 20)];

  wal_buffers =
    max [
      (min [64 (shared_buffers / 32)])
      1];

  listen_addresses =
    if builtins.hasAttr "ethsrv" config.networking.interfaces
    then
      let
        ethsrv = config.networking.interfaces.ethsrv;
      in
        (map (addr: addr.address) ethsrv.ip4) ++
        (map (addr: addr.address) ethsrv.ip6)
    else [];

in
{
  options = {

    flyingcircus.roles.postgresql93 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Flying Circus PostgreSQL 9.3 server role.";
      };
    };

    flyingcircus.roles.postgresql94 = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Flying Circus PostgreSQL 9.4 server role.";
      };
    };

  };

  config = mkIf postgres_enabled {

    services.postgresql.enable = true;
    services.postgresql.package = builtins.getAttr version package;

    services.postgresql.initialScript = ./postgresql-init.sql;
    services.postgresql.dataDir = "/srv/postgresql/${version}";

    users.users.postgres = {
      shell = "/run/current-system/sw/bin/bash";
      home = "/srv/postgresql";
    };
    system.activationScripts.flyingcircus_postgresql = ''
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
      # CONNECTIONS AND AUTHENTICATION
      #------------------------------------------------------------------------------
      listen_addresses = '${concatStringsSep "," listen_addresses},127.0.0.1,::1'
      max_connections = 400
      #------------------------------------------------------------------------------
      # RESOURCE USAGE (except WAL)
      #------------------------------------------------------------------------------
      # available memory: ${toString current_memory}MB
      shared_buffers = ${toString shared_buffers}MB   # starting point is 25% RAM
      temp_buffers = 16MB
      work_mem = ${toString work_mem}MB
      maintenance_work_mem = ${toString maintenance_work_mem}MB
      #------------------------------------------------------------------------------
      # QUERY TUNING
      #------------------------------------------------------------------------------
      effective_cache_size = ${toString (shared_buffers * 2)}MB

      # version-specific resource settings for 9.3
      effective_io_concurrency = 100

      #------------------------------------------------------------------------------
      # WRITE AHEAD LOG
      #------------------------------------------------------------------------------
      wal_level = hot_standby
      wal_buffers = ${toString wal_buffers}MB
      checkpoint_segments = 100
      checkpoint_completion_target = 0.9
      archive_mode = off

      #------------------------------------------------------------------------------
      # ERROR REPORTING AND LOGGING
      #------------------------------------------------------------------------------
      log_min_duration_statement = 1000
      log_checkpoints = on
      log_connections = on
      log_line_prefix = 'user=%u,db=%d '
      log_lock_waits = on
      log_autovacuum_min_duration = 5000
      log_temp_files = 1kB
      shared_preload_libraries = 'auto_explain'
      auto_explain.log_min_duration = '3s'

      #------------------------------------------------------------------------------
      # CLIENT CONNECTION DEFAULTS
      #------------------------------------------------------------------------------
      datestyle = 'iso, mdy'
      lc_messages = 'en_US.utf8'
      lc_monetary = 'en_US.utf8'
      lc_numeric = 'en_US.utf8'
      lc_time = 'en_US.utf8'

    '';

    services.postgresql.authentication = ''
      host all  all  0.0.0.0/0  md5
      host all  all  ::/0       md5
    '';
  };

}
