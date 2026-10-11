{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mesh-llm;

  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "mesh-llm-config.toml" cfg.settings;
in
{
  options.services.mesh-llm = {
    enable = lib.mkEnableOption "a MeshLLM node";

    package = lib.mkPackageOption pkgs "mesh-llm" {
      example = "mesh-llm.override { cudaSupport = true; }";
      extraDescription = ''
        The native runtimes it bundles decide the GPU backends the node can use.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 9337;
      description = "Port of the OpenAI-compatible API.";
    };

    consolePort = lib.mkOption {
      type = lib.types.port;
      default = 3131;
      description = "Port of the web console and management API.";
    };

    meshPort = lib.mkOption {
      type = lib.types.nullOr lib.types.port;
      default = null;
      example = 7842;
      description = ''
        UDP port for the mesh's QUIC traffic between nodes. `null` lets
        MeshLLM pick a random port, which works behind NAT but can't be opened
        in a firewall.
      '';
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open [](#opt-services.mesh-llm.meshPort) (UDP) for other
        nodes, and the API and console ports (TCP) when `--listen-all` is in
        [](#opt-services.mesh-llm.extraArgs).
      '';
    };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      example = {
        models = [ { model = "Qwen3-8B-Q4_K_M"; } ];
      };
      description = ''
        MeshLLM configuration (`~/.mesh-llm/config.toml`), such as the models
        to serve. When set, it replaces the file at every start, so changes
        made in the console are lost. When empty, MeshLLM manages the file.
        It ends up in the Nix store; put secrets in
        [](#opt-services.mesh-llm.environmentFile) instead.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.externalPath;
      default = null;
      example = "/run/secrets/mesh-llm.env";
      description = ''
        Environment file for secrets, such as `MESH_LLM_JOIN_FILE` pointing to
        a private mesh's invite token, or `HF_TOKEN` for gated models.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--auto"
        "--publish"
      ];
      description = "Extra arguments for `mesh-llm serve`.";
    };

    path = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = lib.optional config.hardware.nvidia.enabled config.hardware.nvidia.package.bin;
      defaultText = lib.literalExpression "lib.optional config.hardware.nvidia.enabled config.hardware.nvidia.package.bin";
      description = ''
        Packages on the node's `PATH`. MeshLLM asks `nvidia-smi` for the
        NVIDIA GPUs and their compute capability.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedUDPPorts = lib.optional (cfg.meshPort != null) cfg.meshPort;
      allowedTCPPorts = lib.optionals (lib.elem "--listen-all" cfg.extraArgs) [
        cfg.port
        cfg.consolePort
      ];
    };

    warnings = lib.optional (cfg.openFirewall && cfg.meshPort == null) ''
      services.mesh-llm.openFirewall has no effect on mesh traffic without services.mesh-llm.meshPort.
    '';

    systemd.services.mesh-llm = {
      description = "MeshLLM node";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      inherit (cfg) path;

      # MeshLLM keeps its identity, configuration and model cache in HOME.
      environment.HOME = "/var/lib/mesh-llm";

      preStart = lib.optionalString (cfg.settings != { }) ''
        install -D -m 0600 ${configFile} "$HOME/.mesh-llm/config.toml"
      '';

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "serve"
            "--port"
            (toString cfg.port)
            "--console"
            (toString cfg.consolePort)
            # One event per journal line, instead of redrawn status panels.
            "--log-format"
            "json"
          ]
          ++ lib.optionals (cfg.meshPort != null) [
            "--bind-port"
            (toString cfg.meshPort)
          ]
          ++ cfg.extraArgs
        );
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        DynamicUser = true;
        StateDirectory = "mesh-llm";
        WorkingDirectory = "/var/lib/mesh-llm";
        # GPU device nodes belong to these groups.
        SupplementaryGroups = [
          "render"
          "video"
        ];
        Restart = "on-failure";
        RestartSec = 5;

        # Inference needs the GPU device nodes, so PrivateDevices stays off.
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        UMask = "0077";
      };
    };
  };

  meta = {
    doc = ./mesh-llm.md;
    maintainers = with lib.maintainers; [ kleinbem ];
  };
}
