{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.powerdns-admin;

  configText = ''
    ${cfg.config}
  ''
  + optionalString (cfg.secretKeyFile != null) ''
    with open('${cfg.secretKeyFile}') as file:
      SECRET_KEY = file.read().strip()
  ''
  + optionalString (cfg.saltFile != null) ''
    with open('${cfg.saltFile}') as file:
      SALT = file.read().strip()
  '';
in
{
  options.services.powerdns-admin = {
    enable = mkEnableOption "the PowerDNS web interface";

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = literalExpression ''
        [ "-b" "127.0.0.1:8000" ]
      '';
      description = ''
        Extra arguments passed to powerdns-admin.
      '';
    };

    config = mkOption {
      type = types.str;
      default = "";
      example = ''
        import cachelib

        BIND_ADDRESS = '127.0.0.1'
        PORT = 8000
        SQLALCHEMY_DATABASE_URI = 'postgresql://powerdnsadmin@/powerdnsadmin?host=/run/postgresql'
        SESSION_TYPE = 'cachelib'
        SESSION_CACHELIB = cachelib.simple.SimpleCache()
      '';
      description = ''
        Configuration python file.
        See [the example configuration](https://github.com/ngoduykhanh/PowerDNS-Admin/blob/v${pkgs.powerdns-admin.version}/configs/development.py)
        for options.
        Also see [Flask Session configuration](https://flask-session.readthedocs.io/en/latest/config.html#SESSION_TYPE)
        as the version shipped with NixOS is more recent than the one PowerDNS-Admin expects
        and it requires explicit configuration.
      '';
    };

    secretKeyFile = mkOption {
      type = types.nullOr types.path;
      example = "/etc/powerdns-admin/secret";
      description = ''
        The secret used to sign cookies and email-confirmation links.
        It must be at least 32 characters long, otherwise PowerDNS-Admin refuses
        to start. Generate one with e.g. `openssl rand -hex 32`.
        Set this to null to ignore this setting and configure it through another way.
      '';
    };

    saltFile = mkOption {
      type = types.nullOr types.path;
      example = "/etc/powerdns-admin/salt";
      description = ''
        The bcrypt salt used to hash API keys, in the `$2b$12$` plus 22
        characters form. It must be valid, otherwise PowerDNS-Admin refuses to
        start. Generate one with
        `nix-shell -p 'python3.withPackages (p: [ p.bcrypt ])' --run "python3 -c 'import bcrypt; print(bcrypt.gensalt().decode())'"`.
        Set this to null to ignore this setting and configure it through another way.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.powerdns-admin = {
      description = "PowerDNS web interface";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment.FLASK_CONF = builtins.toFile "powerdns-admin-config.py" configText;
      environment.PYTHONPATH = pkgs.powerdns-admin.pythonPath;
      environment.POWERDNSADMIN_ASSETS_PREBUILT = "1";
      serviceConfig = {
        ExecStart = "${pkgs.powerdns-admin}/bin/powerdns-admin --pid /run/powerdns-admin/pid ${escapeShellArgs cfg.extraArgs}";
        ExecStartPre = [
          "${pkgs.coreutils}/bin/env FLASK_APP=${pkgs.powerdns-admin}/share/powerdnsadmin/__init__.py ${pkgs.python3Packages.flask}/bin/flask db upgrade -d ${pkgs.powerdns-admin}/share/migrations"
          # Fails when the table the last migration creates is missing.
          "${pkgs.coreutils}/bin/env FLASK_APP=${pkgs.powerdns-admin}/share/powerdnsadmin/__init__.py ${pkgs.python3Packages.flask}/bin/flask check-auth-throttle"
        ];
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -TERM $MAINPID";
        PIDFile = "/run/powerdns-admin/pid";
        RuntimeDirectory = "powerdns-admin";
        User = "powerdnsadmin";
        Group = "powerdnsadmin";

        BindReadOnlyPaths = [
          "/nix/store"
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
        ]
        ++ (optional (cfg.secretKeyFile != null) cfg.secretKeyFile)
        ++ (optional (cfg.saltFile != null) cfg.saltFile);
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        # Implies ProtectSystem=strict, which re-mounts all paths
        #DynamicUser = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        # Needs to start a server
        #PrivateNetwork = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        # Would re-mount paths ignored by temporary root
        #ProtectSystem = "strict";
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        # gunicorn needs setuid
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources @keyring"
          # These got removed by the line above but are needed
          "@setuid @chown"
        ];
        TemporaryFileSystem = "/:ro";
        # Does not work well with the temporary root
        #UMask = "0066";
      };
    };

    users.groups.powerdnsadmin = { };
    users.users.powerdnsadmin = {
      description = "PowerDNS web interface user";
      isSystemUser = true;
      group = "powerdnsadmin";
    };
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
