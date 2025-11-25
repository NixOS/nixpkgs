{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.llama-swap;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yaml" cfg.settings;
in
{
  options.services.llama-swap = {
    enable = lib.mkEnableOption "enable the llama-swap service";

    package = lib.mkPackageOption pkgs "llama-swap" { };

    port = lib.mkOption {
      default = 8080;
      example = 11343;
      type = lib.types.port;
      description = ''
        Port that llama-swap listens on.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for llama-swap.
        This adds {option}`port` to [](#opt-networking.firewall.allowedTCPPorts).
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      description = ''
        llama-swap configuration. Refer to the [llama-swap example configuration](https://github.com/mostlygeek/llama-swap/blob/main/config.example.yaml)
        for details on supported values.
      '';
      example = lib.literalExpression ''
        let
          llama-cpp = pkgs.llama-cpp.override { rocmSupport = true; };
          llama-server = lib.getExe' llama-cpp "llama-server";
        in
        {
          healthCheckTimeout = 60;
          models = {
            "some-model" = {
              cmd = "$\{llama-server\} --port ''\${PORT} -m /var/lib/llama-cpp/models/some-model.gguf -ngl 0 --no-webui";
              aliases = [
                "the-best"
              ];
            };
            "other-model" = {
              proxy = "http://127.0.0.1:5555";
              cmd = "$\{llama-server\} --port 5555 -m /var/lib/llama-cpp/models/other-model.gguf -ngl 0 -c 4096 -np 4 --no-webui";
              concurrencyLimit = 4;
            };
          };
        };
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.llama-swap = {
      description = "Model swapping for LLaMA C++ Server (or any local OpenAPI compatible server)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "exec";
        ExecStart = "${lib.getExe cfg.package} --listen :${toString cfg.port} --config ${configFile}";
        Restart = "on-failure";
        RestartSec = 3;

        # for GPU acceleration
        PrivateDevices = false;

        # hardening
        DynamicUser = true;
        CapabilityBoundingSet = "";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        SystemCallErrorNumber = "EPERM";
        ProtectProc = "invisible";
        ProtectHostname = true;
        ProcSubset = "pid";
      };
    };
    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };

  meta.maintainers = with lib.maintainers; [
    jk
    podium868909
  ];
}
