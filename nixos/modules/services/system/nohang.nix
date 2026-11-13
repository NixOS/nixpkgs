{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nohang;

  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
in
{
  meta = {
    maintainers = with lib.maintainers; [ Dev380 ];
  };

  options.services.nohang = {
    enable = mkEnableOption "nohang, a daemon that keeps system responsiveness when Linux is out of memory";

    package = mkPackageOption pkgs "nohang" { };

    configPath = mkOption {
      type = types.either (types.enum [
        "basic"
        "desktop"
      ]) types.path;
      default = "desktop";
      example = literalExpression "./my-nohang-config.conf";
      description = ''
        Configuration file to use with nohang. The default and desktop example configurations in the nohang repository
        can be used by setting this to "basic" or "desktop" (which is the default). Otherwise, you can set it to the path
        of a custom configuration file.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.nohang = {
      description = "Sophisticated low memory handler";
      documentation = [
        "man:nohang(8)"
        "https://github.com/hakavlad/nohang"
      ];
      after = [ "sysinit.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart =
          "${lib.getExe cfg.package} --monitor --config "
          + (
            if cfg.configPath == "basic" then
              "${cfg.package}/etc/nohang/nohang.conf"
            else if cfg.configPath == "desktop" then
              "${cfg.package}/etc/nohang/nohang-desktop.conf"
            else
              cfg.configPath
          );
        Slice = "hostcritical.slice";
        SyslogIdentifier =
          if cfg.configPath == "basic" then
            "nohang"
          else if cfg.configPath == "desktop" then
            "nohang-desktop"
          else
            "nohang-custom-config";
        KillMode = "mixed";
        Restart = "always";
        RestartSec = 0;

        CPUSchedulingResetOnFork = true;
        RestrictRealtime = "yes";

        TasksMax = 25;
        MemoryMax = "100M";
        MemorySwapMax = "100M";

        UMask = 27;
        ProtectSystem = "strict";
        ReadWritePaths = "/var/log";
        InaccessiblePaths = "/home /root";
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        MemoryDenyWriteExecute = "yes";
        RestrictNamespaces = "yes";
        LockPersonality = "yes";
        PrivateTmp = true;
        DeviceAllow = "/dev/kmsg rw";
        DevicePolicy = "closed";

        CapabilityBoundingSet = [
          "CAP_KILL"
          "CAP_IPC_LOCK"
          "CAP_SYS_PTRACE"
          "CAP_DAC_READ_SEARCH"
          "CAP_DAC_OVERRIDE"
          "CAP_AUDIT_WRITE"
          "CAP_SETUID"
          "CAP_SETGID"
          "CAP_SYS_RESOURCE"
          "CAP_SYSLOG"
        ];
      };
    };
  };
}
