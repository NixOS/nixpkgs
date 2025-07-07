{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.urlwatch;
  format = pkgs.formats.yaml { };
  configurationFile = format.generate "urlwatch.yaml" cfg.configuration;
  generateJobString = job: builtins.readFile (format.generate "jobfile" job);
  urlsFile = pkgs.writeText "urls.yaml" (lib.concatMapStringsSep "---\n" generateJobString cfg.jobs);
in
{
  options.services.urlwatch = {
    enable = lib.mkEnableOption "url monitoring service";

    package = lib.mkPackageOption pkgs "urlwatch" { };

    configuration = lib.mkOption {
      description = ''
        See <https://urlwatch.readthedocs.io/en/latest/configuration.html> for all configuration options.
      '';
      default = { };
      example = lib.literalExpression ''
        {
          display = {
            new = false;
            error = true;
          };
        }
      '';
      type = format.type;
    };

    jobs = lib.mkOption {
      description = ''
        See <https://urlwatch.readthedocs.io/en/latest/jobs.html> for all configuration options.
      '';
      example = lib.literalExpression ''
        [
          {
            name = nixos;
            url = https://nixos.org;
          }
        ]
      '';
      type = lib.types.listOf format.type;
    };

    startAt = lib.mkOption {
      description = ''
        Specifies how often to poll for changes.
        See {manpage}`systemd.time(7)`
      '';
      default = "*:0/30";
      example = "Sun 14:00:00";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.urlwatch = {
      description = "urlwatch - monitors webpages for you";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package ];
      serviceConfig = {
        Type = "oneshot";
        DynamicUser = true;
        StateDirectory = "urlwatch";
        StateDirectoryMode = "0700";

        # hardening
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateTmp = "disconnected";
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectProc = "ptraceable";
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_NETLINK AF_UNIX";
        SocketBindDeny = "any";
        CapabilityBoundingSet = "~CAP_BLOCK_SUSPEND CAP_BPF CAP_CHOWN CAP_MKNOD CAP_NET_RAW CAP_PERFMON CAP_SYS_BOOT CAP_SYS_CHROOT CAP_SYS_MODULE CAP_SYS_NICE CAP_SYS_PACCT CAP_SYS_PTRACE CAP_SYS_TIME CAP_SYSLOG CAP_WAKE_ALARM";
        SystemCallFilter = "~@aio:EPERM @chown:EPERM @clock:EPERM @cpu-emulation:EPERM @debug:EPERM @ipc:EPERM @keyring:EPERM @memlock:EPERM @module:EPERM @mount:EPERM @obsolete:EPERM @pkey:EPERM @privileged:EPERM @raw-io:EPERM @reboot:EPERM @resources:EPERM @sandbox:EPERM @setuid:EPERM @swap:EPERM @timer:EPERM";
      };
      startAt = cfg.startAt;
      script = ''
        ${lib.getExe cfg.package} --urls ${urlsFile} --config ${configurationFile} --cache $STATE_DIRECTORY/cache
      '';
    };
  };

  meta.maintainers = [ lib.maintainers.flandweber ];
}
