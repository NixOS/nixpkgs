{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.passless;
  settingsFormat = pkgs.formats.toml { };
  settingsFile = settingsFormat.generate "passless.toml" cfg.settings;
in
{

  options.programs.passless = {
    enable = lib.mkEnableOption "passless";

    package = lib.mkPackageOption pkgs "passless" { };

    users = lib.options.mkOption {
      type = with lib.types; listOf str;
      description = ''
        Users that intend to use passless and should be added to the fido group.
      '';
      default = [ ];
      example = [ "alice" ];
    };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      example = {
        pass.store-path = "/home/alice/.local/share/password-store";
      };
      description = ''
        Configuration included in `config.toml`.

        See <https://github.com/pando85/passless#configuration-1> for documentation or run `passless config print` to see default configuration.
      '';
    };
  };

  config = lib.mkIf config.programs.passless.enable {
    users.groups.fido.members = cfg.users;

    boot.kernelModules = [ "uhid" ];

    services.udev.extraRules = ''
      KERNEL=="uhid", GROUP="fido", MODE="0660"
    '';

    # From https://github.com/pando85/passless/blob/master/contrib/systemd/passless.service
    systemd.user.services.passless = {
      description = "Passless FIDO2 Software Authenticator";
      documentation = [ "https://github.com/pando85/passless" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "default.target" ];
      path = with pkgs; [ config.programs.gnupg.package ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} --config-path ${settingsFile}";
        Restart = "on-failure";
        RestartSec = "5s";
        # Security hardening
        # The application already handles its own memory locking and core dump prevention
        # but we can add additional systemd protections
        NoNewPrivileges = true;
        LimitMEMLOCK = "2M";
        SyslogIdentifier = "passless";

        # Found with shh
        ProtectSystem = "strict";
        PrivateTmp = "disconnected";
        PrivateMounts = "true";
        ProtectKernelTunables = "true";
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = "AF_UNIX";
        SocketBindDeny = [
          "ipv4:tcp"
          "ipv4:udp"
          "ipv6:tcp"
          "ipv6:udp"
        ];
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "CAP_BPF"
          "CAP_CHOWN"
          "CAP_MKNOD"
          "CAP_NET_RAW"
          "CAP_PERFMON"
          "CAP_SYS_BOOT"
          "CAP_SYS_CHROOT"
          "CAP_SYS_MODULE"
          "CAP_SYS_NICE"
          "CAP_SYS_PACCT"
          "CAP_SYS_PTRACE"
          "CAP_SYS_TIME"
          "CAP_SYSLOG"
          "CAP_WAKE_ALARM"
        ];
        SystemCallFilter = [
          "~@aio:EPERM"
          "@chown:EPERM"
          "@clock:EPERM"
          "@cpu-emulation:EPERM"
          "@debug:EPERM"
          "@ipc:EPERM"
          "@keyring:EPERM"
          "@module:EPERM"
          "@mount:EPERM"
          "@obsolete:EPERM"
          "@pkey:EPERM"
          "@privileged:EPERM"
          "@raw-io:EPERM"
          "@reboot:EPERM"
          "@resources:EPERM"
          "@sandbox:EPERM"
          "@setuid:EPERM"
          "@swap:EPERM"
          "@sync:EPERM"
        ];

      };
    };
  };

  meta.maintainers = with lib.maintainers; [ erictapen ];

}
