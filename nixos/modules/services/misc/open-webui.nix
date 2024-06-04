{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) types;

  cfg = config.services.open-webui;
in
{
  options = {
    services.open-webui = {
      enable = lib.mkEnableOption "Open-WebUI server";
      package = lib.mkPackageOption pkgs "open-webui" { };

      stateDir = lib.mkOption {
        type = types.path;
        default = "/var/lib/open-webui";
        description = "State directory of Open-WebUI.";
      };

      host = lib.mkOption {
        type = types.str;
        default = "localhost";
        description = ''
          The host address which the Open-WebUI server HTTP interface listens to.
        '';
      };

      port = lib.mkOption {
        type = types.port;
        default = 8080;
        description = ''
          Which port the Open-WebUI server listens to.
        '';
      };

      environment = lib.mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = ''
          {
            OLLAMA_API_BASE_URL = "http://localhost:11434";
            # Disable authentication
            WEBUI_AUTH = "False";
          }
        '';
        description = "Extra environment variables for Open-WebUI";
      };

      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for Open-WebUI.
          This adds `services.open-webui.port` to `networking.firewall.allowedTCPPorts`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.open-webui = {
      description = "User-friendly WebUI for LLMs";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      preStart = ''
        mkdir -p ${cfg.stateDir}/static
      '';

      environment = {
        STATIC_DIR = "${cfg.stateDir}/static";
        DATA_DIR = "${cfg.stateDir}";
      } // cfg.environment;

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} serve --host ${cfg.host} --port ${toString cfg.port}";
        WorkingDirectory = cfg.stateDir;
        StateDirectory = "open-webui";
        RuntimeDirectory = "open-webui";
        RuntimeDirectoryMode = "0755";
        PrivateTmp = true;
        DynamicUser = true;
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = false; # onnxruntime/capi/onnxruntime_pybind11_state.so: cannot enable executable stack as shared object requires: Permission Denied
        PrivateUsers = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        ProcSubset = "all"; # Error in cpuinfo: failed to parse processor information from /proc/cpuinfo
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        UMask = "0077";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };

  meta.maintainers = with lib.maintainers; [ shivaraj-bh ];
}
