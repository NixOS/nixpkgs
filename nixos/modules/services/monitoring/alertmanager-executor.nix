{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.alertmanager-executor;
  settingsFormat = pkgs.formats.yaml { };
in
{
  options = {
    services.alertmanager-executor = {
      enable = mkEnableOption "alertmanager-executor (aka prometheus-am-executor)";

      user = mkOption {
        type = types.str;
        default = "alertmanager-executor";
        description = "User to run the service and executed commands under.";
      };

      group = mkOption {
        type = types.str;
        default = "alertmanager-executor";
        description = "Group to run the service and executed commands under.";
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "-v" ];
        description = "Extra flags passed to the program.";
      };

      settings = mkOption {
        type = settingsFormat.type;
        default = { };
        example = {
          listen_address = "localhost:23222";
          commands = [
            {
              cmd = "echo";
              args = [
                "alert"
                "firing"
              ];
            }
          ];
        };
        description = ''
          Configuration for alertmanager-executor. Documentation:
          <https://github.com/imgix/prometheus-am-executor#configuration-file-format>.

          Please note that depending on the command you are executing you may have
          to loosen the {manpage}`systemd.exec(5)` sandboxing settings
          under {option}`systemd.services.alertmanager-executor.serviceConfig`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users = optionalAttrs (cfg.user == "alertmanager-executor") {
      alertmanager-executor = {
        description = "Execute command based on Prometheus alerts";
        isSystemUser = true;
        group = cfg.group;
      };
    };

    users.groups = optionalAttrs (cfg.group == "alertmanager-executor") {
      alertmanager-executor = { };
    };

    systemd.services.alertmanager-executor = {
      description = "Execute command based on Prometheus alerts";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.alertmanager-executor}/bin/prometheus-am-executor ${escapeShellArgs cfg.extraFlags} -f ${settingsFormat.generate "executor.yaml" cfg.settings}";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "alertmanager-executor";

        UMask = "0077";
        ProtectSystem = "strict";
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RemoveIPC = true;
        CapabilityBoundingSet = "";
      };
    };
  };
}
