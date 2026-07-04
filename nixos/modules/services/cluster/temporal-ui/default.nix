{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.temporal-ui;

  settingsFormat = pkgs.formats.yaml { };

  usingDefaultUserAndGroup = cfg.user == "temporal-ui" && cfg.group == "temporal-ui";
in
{
  meta.maintainers = [ lib.maintainers.jpds ];

  options.services.temporal-ui = {
    enable = lib.mkEnableOption "Temporal Web UI";

    package = lib.mkPackageOption pkgs "temporal-ui-server" { };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
      };

      default = { };

      example = {
        temporalGrpcAddress = "127.0.0.1:7233";
        port = 8080;
      };

      description = ''
        Temporal Web UI server configuration. `temporalGrpcAddress` must be
        set to the address of the Temporal frontend service, see
        [](#opt-services.temporal.settings).

        See <https://github.com/temporalio/ui-server/blob/main/config/base.yaml>
        for the full set of available options.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "temporal-ui";
      description = ''
        The user Temporal Web UI runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "temporal-ui";
      description = ''
        The group Temporal Web UI runs as. Should be left at default unless
        you have very specific needs.
      '';
    };

    restartIfChanged = lib.mkOption {
      type = lib.types.bool;
      description = ''
        Automatically restart the service on config change.
        This can be set to false to defer restarts on a server or cluster.
        Please consider the security implications of inadvertently running an older version,
        and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
      '';
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.settings ? temporalGrpcAddress && cfg.settings.temporalGrpcAddress != "";
        message = "services.temporal-ui.settings.temporalGrpcAddress must be set to the Temporal frontend gRPC address.";
      }
    ];

    environment.etc."temporal-ui/config/base.yaml".source =
      settingsFormat.generate "temporal-ui-base.yaml" cfg.settings;

    systemd.services.temporal-ui-server = {
      description = "Temporal Web UI server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      inherit (cfg) restartIfChanged;
      restartTriggers = [ config.environment.etc."temporal-ui/config/base.yaml".source ];
      serviceConfig = {
        ExecStart = ''
          ${lib.getExe cfg.package} --root /etc/temporal-ui start
        '';
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        DynamicUser = usingDefaultUserAndGroup;
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_NETLINK"
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @resources"
          "~@privileged"
        ];
      };
    };
  };
}
