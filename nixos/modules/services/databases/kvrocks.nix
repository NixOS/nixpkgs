{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.kvrocks;

  toKeyValue =
    attrs:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        k: v:
        let
          v' =
            if lib.isList v then
              lib.concatStringsSep " " v
            else if lib.isBool v then
              if v then "yes" else "no"
            else
              toString v;
        in
        "${k} ${v'}"
      ) attrs
    );

  configFileFromSettings = pkgs.writeText "kvrocks.conf" (
    toKeyValue (
      lib.recursiveUpdate {
        daemonize = "no";
        dir = "/var/lib/kvrocks";
        pidfile = "/run/kvrocks/kvrocks.pid";
        "log-dir" = "/var/log/kvrocks";
      } cfg.settings
    )
  );
in
{
  options.services.kvrocks = {
    enable = lib.mkEnableOption "kvrocks server";

    package = lib.mkPackageOption pkgs "kvrocks" { };

    configFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      description = ''
        Path to the `kvrocks.conf` file.
        If set, this will be used directly. Otherwise, the configuration
        will be gend from `settings`.
      '';
    };

    settings = lib.mkOption {
      type =
        with lib.types;
        attrsOf (oneOf [
          str
          int
          bool
          (listOf str)
        ]);
      default = { };
      example = lib.literalExpression ''
        {
          port = 6666;
          bind = "127.0.0.1";
          "rocksdb.write_buffer_size" = 128;
        }
      '';
      description = "kvrocks configuration. See kvrocks.conf for details.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.etc."kvrocks/kvrocks.conf" = {
      source = if cfg.configFile != null then cfg.configFile else configFileFromSettings;
      user = "kvrocks";
      group = "kvrocks";
      mode = "0440";
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/kvrocks 0750 kvrocks kvrocks -"
      "d /var/log/kvrocks 0750 kvrocks kvrocks -"
    ];

    users.users.kvrocks = {
      isSystemUser = true;
      group = "kvrocks";
      home = "/var/lib/kvrocks";
    };

    users.groups.kvrocks = { };

    systemd.services.kvrocks = {
      description = "kvrocks server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        User = "kvrocks";
        Group = "kvrocks";
        ExecStart = "${lib.getExe cfg.package} -c /etc/kvrocks/kvrocks.conf";
        PIDFile = "/run/kvrocks/kvrocks.pid";
        RuntimeDirectory = "kvrocks";
        RuntimeDirectoryMode = "0755";
        StandardOutput = "journal";
        StandardError = "journal";
        ReadWritePaths = [
          "/var/lib/kvrocks"
          "/var/log/kvrocks"
        ];
        # Security hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        LockPersonality = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
      };
    };
  };
}
