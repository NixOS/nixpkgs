{ config, lib, pkgs, utils, ... }:
let
  cfg = config.services.pyload;

  stateDir = "/var/lib/pyload";
in
{
  meta.maintainers = with lib.maintainers; [ ambroisie ];

  options = with lib; {
    services.pyload = {
      enable = mkEnableOption "pyLoad download manager";

      package = mkPackageOption pkgs "pyLoad" { default = [ "pyload-ng" ]; };

      listenAddress = mkOption {
        type = types.str;
        default = "localhost";
        example = "0.0.0.0";
        description = "Address to listen on for the web UI.";
      };

      port = mkOption {
        type = types.port;
        default = 8000;
        example = 9876;
        description = "Port to listen on for the web UI.";
      };

      downloadDirectory = mkOption {
        type = types.path;
        default = "${stateDir}/downloads";
        example = "/mnt/downloads";
        description = "Directory to store downloads.";
      };

      user = mkOption {
        type = types.str;
        default = "pyload";
        description = "User under which pyLoad runs, and which owns the download directory.";
      };

      group = mkOption {
        type = types.str;
        default = "pyload";
        description = "Group under which pyLoad runs, and which owns the download directory.";
      };

      credentialsFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/secrets/pyload-credentials.env";
        description = ''
          File containing {env}`PYLOAD_DEFAULT_USERNAME` and
          {env}`PYLOAD_DEFAULT_PASSWORD` in the format of an `EnvironmentFile=`,
          as described by {manpage}`systemd.exec(5)`.

          If not given, they default to the username/password combo of
          pyload/pyload.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.settings.pyload = {
      ${cfg.downloadDirectory}.d = { inherit (cfg) user group; };
    };

    systemd.services.pyload = {
      description = "pyLoad download manager";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      # NOTE: unlike what the documentation says, it looks like `HOME` is not
      # defined with this service definition...
      # Since pyload tries to do the equivalent of `cd ~`, it needs to be able
      # to resolve $HOME, which fails when `RootDirectory` is set.
      # FIXME: check if `SetLoginEnvironment` fixes this issue in version 255
      environment = {
        HOME = stateDir;
        PYLOAD__WEBUI__HOST = cfg.listenAddress;
        PYLOAD__WEBUI__PORT = builtins.toString cfg.port;
      };

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs [
          (lib.getExe cfg.package)
          "--userdir"
          "${stateDir}/config"
          "--storagedir"
          cfg.downloadDirectory
        ];

        User = cfg.user;
        Group = cfg.group;

        EnvironmentFile = lib.optional (cfg.credentialsFile != null) cfg.credentialsFile;

        StateDirectory = "pyload";
        WorkingDirectory = stateDir;
        RuntimeDirectory = "pyload";
        RuntimeDirectoryMode = "0700";
        RootDirectory = "/run/pyload";
        BindReadOnlyPaths = [
          builtins.storeDir # Needed to run the python interpreter
        ];
        BindPaths = [
          cfg.downloadDirectory
        ];

        # Hardening options
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@resources" "~@privileged" ];
        UMask = "0002";
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "~CAP_BPF"
          "~CAP_CHOWN"
          "~CAP_IPC_LOCK"
          "~CAP_KILL"
          "~CAP_LEASE"
          "~CAP_LINUX_IMMUTABLE"
          "~CAP_NET_ADMIN"
          "~CAP_SYS_ADMIN"
          "~CAP_SYS_BOOT"
          "~CAP_SYS_CHROOT"
          "~CAP_SYS_NICE"
          "~CAP_SYS_PACCT"
          "~CAP_SYS_PTRACE"
          "~CAP_SYS_RESOURCE"
          "~CAP_SYS_TTY_CONFIG"
        ];
      };
    };

    users.users.pyload = lib.mkIf (cfg.user == "pyload") {
      isSystemUser = true;
      group = cfg.group;
      home = stateDir;
    };

    users.groups.pyload = lib.mkIf (cfg.group == "pyload") { };
  };
}
