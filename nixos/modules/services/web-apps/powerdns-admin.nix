{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.powerdns-admin;

  configText = ''
    ${cfg.config}
  ''
  + optionalString (cfg.secretKeyFile != null) ''
    with open('${cfg.secretKeyFile}') as file:
      SECRET_KEY = file.read()
  ''
  + optionalString (cfg.saltFile != null) ''
    with open('${cfg.saltFile}') as file:
      SALT = file.read()
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
      description = lib.mdDoc ''
        Extra arguments passed to powerdns-admin.
      '';
    };

    config = mkOption {
      type = types.str;
      default = "";
      example = ''
        BIND_ADDRESS = '127.0.0.1'
        PORT = 8000
        SQLALCHEMY_DATABASE_URI = 'postgresql://powerdnsadmin@/powerdnsadmin?host=/run/postgresql'
      '';
      description = lib.mdDoc ''
        Configuration python file.
        See [the example configuration](https://github.com/ngoduykhanh/PowerDNS-Admin/blob/v${pkgs.powerdns-admin.version}/configs/development.py)
        for options.
      '';
    };

    secretKeyFile = mkOption {
      type = types.nullOr types.path;
      example = "/etc/powerdns-admin/secret";
      description = lib.mdDoc ''
        The secret used to create cookies.
        This needs to be set, otherwise the default is used and everyone can forge valid login cookies.
        Set this to null to ignore this setting and configure it through another way.
      '';
    };

    saltFile = mkOption {
      type = types.nullOr types.path;
      example = "/etc/powerdns-admin/salt";
      description = lib.mdDoc ''
        The salt used for serialization.
        This should be set, otherwise the default is used.
        Set this to null to ignore this setting and configure it through another way.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.powerdns-admin = {
      description = "PowerDNS web interface";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];

      environment.FLASK_CONF = builtins.toFile "powerdns-admin-config.py" configText;
      environment.PYTHONPATH = pkgs.powerdns-admin.pythonPath;
      serviceConfig = {
        ExecStart = "${pkgs.powerdns-admin}/bin/powerdns-admin --pid /run/powerdns-admin/pid ${escapeShellArgs cfg.extraArgs}";
        ExecStartPre = "${pkgs.coreutils}/bin/env FLASK_APP=${pkgs.powerdns-admin}/share/powerdnsadmin/__init__.py ${pkgs.python3Packages.flask}/bin/flask db upgrade -d ${pkgs.powerdns-admin}/share/migrations";
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        ExecStop = "${pkgs.coreutils}/bin/kill -TERM $MAINPID";
        PIDFile = "/run/powerdns-admin/pid";
        RuntimeDirectory = "powerdns-admin";
        User = "powerdnsadmin";
        Group = "powerdnsadmin";

        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        BindReadOnlyPaths = [
          "/nix/store"
          "-/etc/resolv.conf"
          "-/etc/nsswitch.conf"
          "-/etc/hosts"
          "-/etc/localtime"
        ]
        ++ (optional (cfg.secretKeyFile != null) cfg.secretKeyFile)
        ++ (optional (cfg.saltFile != null) cfg.saltFile);
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
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
