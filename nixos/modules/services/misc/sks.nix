{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sks;
  pkg = pkgs.sks;

  sksCfg = pkgs.writeText "sksconf"
    ''
      #  sksconf -- SKS main configuration

      basedir: ${cfg.dataDir}

      hostname: ${cfg.hostname}

      hkp_address: ${concatStringsSep " " cfg.hkpAddr}
      hkp_port: ${toString cfg.hkpPort}

      recon_address: ${concatStringsSep " " cfg.reconAddr}
      recon_port: ${toString cfg.reconPort}

      #\${optionalString (cfg.mode == "standalone") "disable_mailsync:"}

      ${sksAdditionalCfg}

      ${sksDBCfg}
    '';

  sksAdditionalCfg = ''
    # debuglevel 3 is default (max. debuglevel is 10)
    debuglevel: 3

    #\${optionalString (cfg.mode == "synchronizing")
      "membership_reload_interval: 1"}

    # Run database statistics calculation on boot and every day at 04:00h
    # Can be manually triggered with the USR2 signal.
    initial_stat:
    stat_hour: 4

    # TODO: Introduce options for that
    #server_contact: 0xDECAFBADDEADBEEF
    #from_addr: pgp-public-keys@example.tld
    #sendmail_cmd: /usr/sbin/sendmail -t -oi
  '';

  sksDBCfg = ''
    # set DB file pagesize as recommended by db_tuner
    # pagesize is (n * 512) bytes
    # NOTE: These must be set _BEFORE_ [fast]build & pbuild and remain set
    # for the life of the database files. To change a value requires recreating
    # the database from a dump

    # KDB/key 65536
    pagesize: 128

    # KDB/keyid 32768
    keyid_pagesize: 64

    # KDB/meta 512
    meta_pagesize: 1

    # KDB/subkeyid 65536
    subkeyid_pagesize: 128

    # KDB/time 65536
    time_pagesize: 128

    # KDB/tqueue 512
    tqueue_pagesize: 1

    # KDB/word - db_tuner suggests 512 bytes. This locked the build process
    # Better to use a default of 8 (4096 bytes) for now
    #word_pagesize: 8

    # PTree/ptree 4096
    ptree_pagesize: 8
  '';

  membershipCfg = pkgs.writeText "membership" ''
    # With SKS, two hosts can efficiently compare their databases then
    # repair whatever differences are found.  In order to set up
    # reconciliation, you first need to find other SKS servers that will
    # agree to gossip with you. The hostname and port of the server that
    # has agreed to do so should be added to this file.
    #
    # Empty lines and whitespace-only lines are ignored, as are lines
    # whose first non-whitespace character is a `#'. Comments preceded by '#'
    # are allowed at the ends of lines
    #
    # Example:
    # keyserver.linux.it 11370
    #
    #
    ${membershipAdditionalCfg}
  '';

  membershipAdditionalCfg = ''
    # The following operators have agreed to have their peering info included in this sample file.
    # NOTE: This does NOT mean you may uncomment the lines and have peers. First you must contact the
    # server owner and ask permission. You should include a line styled like these for your own server.
    # Until two SKS membership files contain eact others peering info, they will not gossip.
    #
    #yourserver.example.net   11370 # Your full name <emailaddress for admin purposes> 0xPreferrefPGPkey
    #keyserver.gingerbear.net 11370 # John P. Clizbe <John@Gingerbear.net>             0xD6569825
    #sks.keyservers.net       11370 # John P. Clizbe <John@Gingerbear.net>             0xD6569825
    #keyserver.rainydayz.org  11370 # Andy Ruddock <andy.ruddock@rainydayz.org>        0xEEC3AFB3
    #keyserver.computer42.org 11370 # H.-Dirk Schmitt <dirk@computer42.org>            0x6A017B17
  '';

  # TODO: Check if still required (I'll ask on the sks ML)
  dbCfg = pkgs.writeText "DB_CONFIG"
    ''
      set_mp_mmapsize  268435456
      set_cachesize    0 134217728 1
      set_flags        DB_LOG_AUTOREMOVE
      set_lg_regionmax 1048576
      set_lg_max       104857600
      set_lg_bsize     2097152
      set_lk_detect    DB_LOCK_DEFAULT
      set_tmp_dir      /tmp
      set_lock_timeout 1000
      set_txn_timeout  1000
      mutex_set_max    65536
    '';
in
{
###### interface
  options = {
    services.sks = {

      enable = mkEnableOption "Whether to enable sks (synchronizing key server
      for OpenPGP) and start the database server";

      enableRecon = mkEnableOption "Whether to enable the reconciliation server
      of sks";

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/sks";
        description = ''
          Data directory (-basedir) for sks, where the database and all
          configuration files are located (e.g. KDB, PTree, membership and
          sksconf).
        '';
      };

      dumpDir = mkOption {
        type = types.path;
        default = "~/dump";
        description = ''
          Keydump directory, where all keys for the initial import are located.
          This option is required and one must import at least one key (even
          for a standalone server). The path can be absolute or relative to the
          dataDir.
        '';
      };

      mode = mkOption {
        type = types.enum ["standalone" "synchronizing"];
        default = "standalone";
        description = ''
          Whether this is a standalone key server (default, e.g. for key
          signing parties, personal key server) or a synchronizing key server
          (please read
          https://bitbucket.org/skskeyserver/sks-keyserver/wiki/Peering first).
        '';
      };

      # TODO: default =
      # "\${config.networking.hostName}.\${config.networking.domain}";?
      hostname = mkOption {
        type = types.str;
        default = "localhost";
        example = "keyserver.example.tld";
        description = "The hostname (should be the public facing FQDN if
        available) used for sks.";
      };

     # TODO: "hkpAddr", "hkpListenAddress" or "hkp.listenAddress"?
     hkpAddr = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" "::1" ];
        description = "Domain names, IPv4 and/or IPv6 addresses to listen on
        for HKP requests.";
      };

      hkpPort = mkOption {
        type = types.int;
        default = 11371;
        description = "HKP port to listen on.";
      };

     reconAddr = mkOption {
        type = types.listOf types.str;
        default = [ "127.0.0.1" "::1" ];
        description = "Domain names, IPv4 and/or IPv6 addresses to listen on.";
      };

      reconPort = mkOption {
        type = types.int;
        default = 11370;
        description = "Recon port to listen on.";
      };

      additionalConfig = mkOption {
        type = types.lines;
        default = sksAdditionalCfg;
        description = "Provide additional sks configuration options which will
        be appended to the main configuration (sksconf). See \"ADDITIONAL
        OPTIONS\" in \"man sks\" for all available options.";
      };

      dbConfig = mkOption {
        type = types.lines;
        default = sksDBCfg;
        description = "The part of sksconf related to the database.";
      };

      sksconfFile = mkOption {
        type = types.path;
        default = sksCfg;
        defaultText = "sks configuration file";
        description = "Derivation for the main configuration file of sks. You
        can use this option to replace the default configuration, however it's
        recommended to use the options provided by this module instead and use
        the \"additionalConfig\" option for options not implemented by this
        module.";
      };

      membershipAdditionalCfg = mkOption {
        type = types.lines;
        default = sksAdditionalCfg;
        description = "With SKS, two hosts can efficiently compare their
        databases then repair whatever differences are found. In order to set
        up reconciliation, you first need to find other SKS servers that will
        agree to gossip with you. The hostname and port of the server that has
        agreed to do so should be added here.";
      };

      membershipFile = mkOption {
        type = types.path;
        default = membershipCfg;
        defaultText = "sks membership file";
        description = "Derivation for the membership configuration file of sks. You
        can use this option to replace the default configuration, however it's
        recommended to use \"membershipAdditionalCfg\" instead.";
      };
    };
  };
###### implementation
  config = mkMerge
  [
    (mkIf cfg.enable {

      # TODO
      #warnings = ...

      #environment.systemPackages = [ pkg ];

      users.users."sks" = {
        description = "SKS keyserver user";
        uid = config.ids.uids.sks;
        group = "sks";
        home = cfg.dataDir;
        createHome  = true;
        useDefaultShell = true; # For manual interaction
      };

      users.groups."sks".gid = config.ids.gids.sks;

      # Create symbolic links for all configuration files (/etc/sks)
      environment.etc = {
        "sks/sksconf".source = sksconfFile;
        "sks/DB_CONFIG".source = dbCfg;
      };

      #system.activationScripts

      # TODO - Merging?
      #services.logrotate = {
      #  enable = true;
      #  # TODO - /var/log/sks/*.log or db only?
      #  config = ''
      #    /var/log/sks/db.log {
      #      rotate 4 # Keep 4 old versions.
      #      weekly
      #      notifempty
      #      missingok
      #      delaycompress
      #      sharedscripts
      #      #postrotate
      #      #  /bin/kill -HUP `cat /var/run/sks-db.pid    2>/dev/null` 2>/dev/null || true
      #      #  /bin/kill -HUP `cat /var/run/sks-recon.pid 2>/dev/null` 2>/dev/null || true
      #      #endscript
      #    }
      #  '';
      #};

      # Info:
      # - Using 'WorkingDirectory' or '-basedir' within the systemd service
      #   declaration is not necessary since the former defaults to the user's
      #   home directory.

      systemd.services."sks-db" = {
        description = "SKS database server";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkg ]; # pkg = sks
        serviceConfig = {
          Type = "simple";
          ExecStart = "sks db";
          User = "sks";
        };
        preStart = ''
          #ln -fsn ${sksconfFile} ${cfg.dataDir}/sksconf
          #ln -fsn ${dbCfg} ${cfg.dataDir}/DB_CONFIG

          # Create symbolic links for all configuration files (/etc/sks)
          #ln -fsn /etc/sks/DB_CONFIG ${cfg.dataDir}/DB_CONFIG
          #ln -fsn /etc/sks/sksconf ${cfg.dataDir}/sksconf

          # Create all missing log files
          if ! test -e ${cfg.dataDir}/db.log; then
            touch ${cfg.dataDir}/db.log
          fi
          if ! test -e ${cfg.dataDir}/build.log; then
            touch ${cfg.dataDir}/build.log
          fi
          if ! test -e ${cfg.dataDir}/dump.log; then
            touch ${cfg.dataDir}/dump.log
          fi

          # Create symbolic links in /var/log/sks for all log files
          mkdir -p /var/log/sks
          ln -fsn ${cfg.dataDir}/db.log /var/log/sks/db.log
          ln -fsn ${cfg.dataDir}/build.log /var/log/sks/build.log
          ln -fsn ${cfg.dataDir}/dump.log /var/log/sks/dump.log

          # Build the key database if missing
          if ! test -e ${cfg.dataDir}/KDB; then
            # We have to import a dump or at least one key!
            ${pkg}/bin/sks build ${dumpDir}/*.pgp -n 10 -cache 100
            ${pkg}/bin/sks cleandb
            ${pkg}/bin/sks pbuild -cache 20 -ptree_cache 70
          fi
        '';
      };
    })

    (mkIf (cfg.enable && cfg.enableRecon) {

      systemd.services."sks-recon" = {
        description = "SKS reconciliation server";
        bindsTo = [ "sks-db.service" ];
        after = [ "sks-db.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkg}/bin/sks recon -basedir ${cfg.dataDir}";
          WorkingDirectory = cfg.dataDir;
          User = "sks";
        };
        preStart = ''
          ln -fsn /var/log/sks/recon.log ${cfg.dataDir}
        '';
      };
    })
  ];

  meta = {
    maintainers = with maintainers; [ primeos jcumming ];
  };
}
