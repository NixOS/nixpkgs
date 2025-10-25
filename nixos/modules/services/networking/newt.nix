{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.newt;
  type =
    with lib.types;
    attrsOf (
      nullOr (oneOf [
        bool
        int
        float
        str
        path
        (listOf type)
      ])
    )
    // {
      description = "value coercible to CLI argument";
    };
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "newt" "id" ] [ "services" "newt" "settings" "id" ])
    (lib.mkRenamedOptionModule
      [ "services" "newt" "logLevel" ]
      [ "services" "newt" "settings" "log-level" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "newt" "endpoint" ]
      [ "services" "newt" "settings" "endpoint" ]
    )
  ];

  options = {
    services.newt = {
      enable = lib.mkEnableOption "Newt, user space tunnel client for Pangolin";
      package = lib.mkPackageOption pkgs "fosrl-newt" { };
      settings = lib.mkOption {
        inherit type;
        default = { };
        example = {
          endpoint = "pangolin.example.com";
          id = "8yfsghj438a20ol";
        };
        description = "Settings for Newt module, see [Newt CLI docs](https://github.com/fosrl/newt?tab=readme-ov-file#cli-args) for more information.";
      };

      # provide path to file to keep secrets out of the nix store
      environmentFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        description = ''
          Path to a file containing sensitive environment variables for Newt. See <https://docs.fossorial.io/Newt/overview#cli-args>
          These will overwrite anything defined in the config.
          The file should contain environment-variable assignments like:
          NEWT_ID=2ix2t8xk22ubpfy
          NEWT_SECRET=nnisrfsdfc7prqsp9ewo1dvtvci50j5uiqotez00dgap0ii2
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.environmentFile != null;
        message = "services.newt.environmentFile must be provided when Newt is enabled.";
      }
    ];

    systemd.services.newt = {
      description = "Newt, user space tunnel client for Pangolin";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      environment = {
        HOME = "/var/lib/private/newt";
      };
      # the flag values will all be overwritten if also defined in the env file
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} ${lib.cli.toCommandLineShellGNU { } cfg.settings}";
        DynamicUser = true;
        StateDirectory = "newt";
        StateDirectoryMode = "0700";
        Restart = "always";
        RestartSec = "10s";
        EnvironmentFile = cfg.environmentFile;
        # hardening
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = "disconnected";
        PrivateDevices = true;
        PrivateUsers = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        ProtectProc = "noaccess";
        ProtectHostname = true;
        RemoveIPC = true;
        NoNewPrivileges = true;
        RestrictSUIDSGID = true;
        MemoryDenyWriteExecute = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "~CAP_BPF"
          "~CAP_CHOWN"
          "~CAP_MKNOD"
          "~CAP_NET_RAW"
          "~CAP_PERFMON"
          "~CAP_SYS_BOOT"
          "~CAP_SYS_CHROOT"
          "~CAP_SYS_MODULE"
          "~CAP_SYS_NICE"
          "~CAP_SYS_PACCT"
          "~CAP_SYS_PTRACE"
          "~CAP_SYS_TIME"
          "~CAP_SYS_TTY_CONFIG"
          "~CAP_SYSLOG"
          "~CAP_WAKE_ALARM"
        ];
        SystemCallFilter = [
          "~@aio:EPERM"
          "~@chown:EPERM"
          "~@clock:EPERM"
          "~@cpu-emulation:EPERM"
          "~@debug:EPERM"
          "~@keyring:EPERM"
          "~@memlock:EPERM"
          "~@module:EPERM"
          "~@mount:EPERM"
          "~@obsolete:EPERM"
          "~@pkey:EPERM"
          "~@privileged:EPERM"
          "~@raw-io:EPERM"
          "~@reboot:EPERM"
          "~@resources:EPERM"
          "~@sandbox:EPERM"
          "~@setuid:EPERM"
          "~@swap:EPERM"
          "~@sync:EPERM"
          "~@timer:EPERM"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ jackr ];
}
