{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.cyrus-imap;
  cyrus-imapdPkg = pkgs.cyrus-imapd;
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    optionalAttrs
    optionalString
    generators
    mapAttrsToList
    boolToYesNo
    ;
  inherit (lib.strings) concatStringsSep;
  inherit (lib.types)
    attrsOf
    submodule
    listOf
    oneOf
    str
    int
    bool
    nullOr
    path
    ;

  mkCyrusConfig =
    settings:
    let
      mkCyrusOptionsList =
        v:
        mapAttrsToList (
          p: q:
          if (q != null) then
            if builtins.isInt q then
              "${p}=${builtins.toString q}"
            else
              "${p}=\"${if builtins.isList q then (concatStringsSep " " q) else q}\""
          else
            ""
        ) v;
      mkCyrusOptionsString = v: concatStringsSep " " (mkCyrusOptionsList v);
    in
    concatStringsSep "\n  " (mapAttrsToList (n: v: n + " " + (mkCyrusOptionsString v)) settings);

  cyrusConfig = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (n: v: ''
      ${n} {
        ${mkCyrusConfig v}
      }
    '') cfg.cyrusSettings
  );

  imapdConfig =
    with generators;
    toKeyValue {
      mkKeyValue = mkKeyValueDefault {
        mkValueString =
          v:
          if builtins.isBool v then
            boolToYesNo v
          else if builtins.isList v then
            concatStringsSep " " v
          else
            mkValueStringDefault { } v;
      } ": ";
    } cfg.imapdSettings;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "cyrus-imap" "sslServerCert" ]
      [ "services" "cyrus-imap" "imapdSettings" "tls_server_cert" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "cyrus-imap" "sslServerKey" ]
      [ "services" "cyrus-imap" "imapdSettings" "tls_server_key" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "cyrus-imap" "sslCACert" ]
      [ "services" "cyrus-imap" "imapdSettings" "tls_client_ca_file" ]
    )
  ];
  options.services.cyrus-imap = {
    enable = mkEnableOption "Cyrus IMAP, an email, contacts and calendar server";
    debug = mkEnableOption "debugging messages for the Cyrus master process";

    listenQueue = mkOption {
      type = int;
      default = 32;
      description = ''
        Socket listen queue backlog size. See {manpage}`listen(2)` for more information about a backlog.
        Default is 32, which may be increased if you have a very high connection rate.
      '';
    };
    tmpDBDir = mkOption {
      type = path;
      default = "/run/cyrus/db";
      description = ''
        Location where DB files are stored.
        Databases in this directory are recreated upon startup, so ideally they should live in ephemeral storage for best performance.
      '';
    };
    cyrusSettings = mkOption {
      type = submodule {
        freeformType = attrsOf (
          attrsOf (oneOf [
            bool
            int
            (listOf str)
          ])
        );
        options = {
          START = mkOption {
            default = {
              recover = {
                cmd = [
                  "ctl_cyrusdb"
                  "-r"
                ];
              };
            };
            description = ''
              This section lists the processes to run before any SERVICES are spawned.
              This section is typically used to initialize databases.
              Master itself will not startup until all tasks in START have completed, so put no blocking commands here.
            '';
          };
          SERVICES = mkOption {
            default = {
              imap = {
                cmd = [ "imapd" ];
                listen = "imap";
                prefork = 0;
              };
              pop3 = {
                cmd = [ "pop3d" ];
                listen = "pop3";
                prefork = 0;
              };
              lmtpunix = {
                cmd = [ "lmtpd" ];
                listen = "/run/cyrus/lmtp";
                prefork = 0;
              };
              notify = {
                cmd = [ "notifyd" ];
                listen = "/run/cyrus/notify";
                proto = "udp";
                prefork = 0;
              };
            };
            description = ''
              This section is the heart of the cyrus.conf file. It lists the processes that should be spawned to handle client connections made on certain Internet/UNIX sockets.
            '';
          };
          EVENTS = mkOption {
            default = {
              tlsprune = {
                cmd = [ "tls_prune" ];
                at = 400;
              };
              delprune = {
                cmd = [
                  "cyr_expire"
                  "-E"
                  "3"
                ];
                at = 400;
              };
              deleteprune = {
                cmd = [
                  "cyr_expire"
                  "-E"
                  "4"
                  "-D"
                  "28"
                ];
                at = 430;
              };
              expungeprune = {
                cmd = [
                  "cyr_expire"
                  "-E"
                  "4"
                  "-X"
                  "28"
                ];
                at = 445;
              };
              checkpoint = {
                cmd = [
                  "ctl_cyrusdb"
                  "-c"
                ];
                period = 30;
              };
            };
            description = ''
              This section lists processes that should be run at specific intervals, similar to cron jobs. This section is typically used to perform scheduled cleanup/maintenance.
            '';
          };
          DAEMON = mkOption {
            default = { };
            description = ''
              This section lists long running daemons to start before any SERVICES are spawned. {manpage}`master(8)` will ensure that these processes are running, restarting any process which dies or forks. All listed processes will be shutdown when {manpage}`master(8)` is exiting.
            '';
          };
        };
      };
      description = "Cyrus configuration settings. See [cyrus.conf(5)](https://www.cyrusimap.org/imap/reference/manpages/configs/cyrus.conf.html)";
    };
    imapdSettings = mkOption {
      type = submodule {
        freeformType = attrsOf (oneOf [
          str
          int
          bool
          (listOf str)
        ]);
        options = {
          configdirectory = mkOption {
            type = path;
            default = "/var/lib/cyrus";
            description = ''
              The pathname of the IMAP configuration directory.
            '';
          };
          lmtpsocket = mkOption {
            type = path;
            default = "/run/cyrus/lmtp";
            description = ''
              Unix socket that lmtpd listens on, used by {manpage}`deliver(8)`. This should match the path specified in {manpage}`cyrus.conf(5)`.
            '';
          };
          idlesocket = mkOption {
            type = path;
            default = "/run/cyrus/idle";
            description = ''
              Unix socket that idled listens on.
            '';
          };
          notifysocket = mkOption {
            type = path;
            default = "/run/cyrus/notify";
            description = ''
              Unix domain socket that the mail notification daemon listens on.
            '';
          };
        };
      };
      default = {
        admins = [ "cyrus" ];
        allowplaintext = true;
        defaultdomain = "localhost";
        defaultpartition = "default";
        duplicate_db_path = "/run/cyrus/db/deliver.db";
        hashimapspool = true;
        httpmodules = [
          "carddav"
          "caldav"
        ];
        mboxname_lockpath = "/run/cyrus/lock";
        partition-default = "/var/lib/cyrus/storage";
        popminpoll = 1;
        proc_path = "/run/cyrus/proc";
        ptscache_db_path = "/run/cyrus/db/ptscache.db";
        sasl_auto_transition = true;
        sasl_pwcheck_method = [ "saslauthd" ];
        sievedir = "/var/lib/cyrus/sieve";
        statuscache_db_path = "/run/cyrus/db/statuscache.db";
        syslog_prefix = "cyrus";
        tls_client_ca_dir = "/etc/ssl/certs";
        tls_session_timeout = 1440;
        tls_sessions_db_path = "/run/cyrus/db/tls_sessions.db";
        virtdomains = "on";
      };
      description = "IMAP configuration settings. See [imapd.conf(5)](https://www.cyrusimap.org/imap/reference/manpages/configs/imapd.conf.html)";
    };

    user = mkOption {
      type = nullOr str;
      default = null;
      description = "Cyrus IMAP user name. If this is not set, a user named `cyrus` will be created.";
    };

    group = mkOption {
      type = nullOr str;
      default = null;
      description = "Cyrus IMAP group name. If this is not set, a group named `cyrus` will be created.";
    };

    imapdConfigFile = mkOption {
      type = nullOr path;
      default = null;
      description = "Path to the configuration file used for cyrus-imap.";
      apply = v: if v != null then v else pkgs.writeText "imapd.conf" imapdConfig;
    };

    cyrusConfigFile = mkOption {
      type = nullOr path;
      default = null;
      description = "Path to the configuration file used for Cyrus.";
      apply = v: if v != null then v else pkgs.writeText "cyrus.conf" cyrusConfig;
    };
  };

  config = mkIf cfg.enable {
    users.users.cyrus = optionalAttrs (cfg.user == null) {
      description = "Cyrus IMAP user";
      isSystemUser = true;
      group = optionalString (cfg.group == null) "cyrus";
    };

    users.groups.cyrus = optionalAttrs (cfg.group == null) { };

    environment.etc."imapd.conf".source = cfg.imapdConfigFile;
    environment.etc."cyrus.conf".source = cfg.cyrusConfigFile;

    systemd.services.cyrus-imap = {
      description = "Cyrus IMAP server";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [
        "/etc/imapd.conf"
        "/etc/cyrus.conf"
      ];

      startLimitIntervalSec = 60;
      environment = {
        CYRUS_VERBOSE = mkIf cfg.debug "1";
        LISTENQUEUE = builtins.toString cfg.listenQueue;
      };
      serviceConfig = {
        User = if (cfg.user == null) then "cyrus" else cfg.user;
        Group = if (cfg.group == null) then "cyrus" else cfg.group;
        Type = "simple";
        ExecStart = "${cyrus-imapdPkg}/libexec/master -l $LISTENQUEUE -C /etc/imapd.conf -M /etc/cyrus.conf -p /run/cyrus/master.pid -D";
        Restart = "on-failure";
        RestartSec = "1s";
        RuntimeDirectory = "cyrus";
        StateDirectory = "cyrus";

        # Hardening
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        PrivateTmp = true;
        PrivateDevices = true;
        ProtectSystem = "full";
        CapabilityBoundingSet = [ "~CAP_NET_ADMIN CAP_SYS_ADMIN CAP_SYS_BOOT CAP_SYS_MODULE" ];
        MemoryDenyWriteExecute = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
      };
      preStart = ''
        mkdir -p '${cfg.imapdSettings.configdirectory}/socket' '${cfg.tmpDBDir}' /run/cyrus/proc /run/cyrus/lock
      '';
    };
    environment.systemPackages = [ cyrus-imapdPkg ];
  };
}
