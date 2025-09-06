{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.sshwifty;
  format = pkgs.formats.json { };
  settings = format.generate "sshwifty.json" cfg.settings;
in
{
  options.services.sshwifty = {
    enable = lib.mkEnableOption "Sshwifty";
    package = lib.mkPackageOption pkgs "sshwifty" { };
    settings = lib.mkOption {
      type = format.type;
      description = ''
        Configuration for Sshwifty. See
        <https://github.com/nirui/sshwifty/tree/master?tab=readme-ov-file#configuration>
        for possible options.
      '';
    };
    sharedKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the shared key.";
    };
    socks5PasswordFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to a file containing the SOCKS5 password.";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "sshwifty";
      description = "The user Sshwifty should run as.";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "sshwifty";
      description = "The group Sshwifty should run as.";
    };
  };
  config = lib.mkIf cfg.enable {
    users.users = lib.mkIf (cfg.user == "sshwifty") {
      sshwifty = {
        name = "sshwifty";
        group = cfg.group;
        isSystemUser = true;
      };
    };
    users.groups = lib.mkIf (cfg.group == "sshwifty") { sshwifty = { }; };

    systemd.services.sshwifty = {
      description = "Sshwifty";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        ${lib.optionalString (cfg.sharedKeyFile != null || cfg.socks5PasswordFile != null) (
          lib.concatStringsSep " " [
            (lib.getExe pkgs.jq)
            "-s"
            "'.[0] * .[1]"
            (lib.optionalString (cfg.sharedKeyFile != null && cfg.socks5PasswordFile != null) "* .[2]")
            "'"
            settings
            (lib.optionalString (
              cfg.sharedKeyFile != null
            ) "<(echo \"{\\\"SharedKey\\\":\\\"$(cat ${cfg.sharedKeyFile})\\\"}\")")
            (lib.optionalString (
              cfg.socks5PasswordFile != null
            ) "<(echo \"{\\\"Socks5Password\\\":\\\"$(cat ${cfg.socks5PasswordFile})\\\"}\")")
            "> /run/sshwifty/sshwifty.json"
          ]
        )}
        ${lib.optionalString (
          cfg.sharedKeyFile != null || cfg.socks5PasswordFile != null
        ) "export SSHWIFTY_CONFIG=/run/sshwifty/sshwifty.json"}
        ${lib.optionalString (
          cfg.sharedKeyFile == null && cfg.socks5PasswordFile == null
        ) "export SSHWIFTY_CONFIG=${settings}"}
        exec ${lib.getExe cfg.package}
      '';
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        RuntimeDirectory = "sshwifty";
        RuntimeDirectoryMode = "0750";
        # Hardening
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        PrivateTmp = "disconnected";
        ProcSubset = "pid";
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = [
          "~cgroup"
          "~ipc"
          "~mnt"
          "~net"
          "~pid"
          "~user"
          "~uts"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@resources"
          "~@swap"
        ];
        UMask = "0077";
      };
    };
  };
  meta.maintainers = [ lib.maintainers.ungeskriptet ];
}
