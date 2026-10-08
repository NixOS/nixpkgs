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
      example = "mesh-llm-cuda";
      extraDescription = ''
        The native runtimes it bundles decide the GPU backends the node can use.
      '';
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
      description = "Whether to open [](#opt-services.mesh-llm.meshPort) (UDP) for other nodes.";
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
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = lib.mkIf (cfg.openFirewall && cfg.meshPort != null) [
      cfg.meshPort
    ];

    warnings = lib.optional (cfg.openFirewall && cfg.meshPort == null) ''
      services.mesh-llm.openFirewall has no effect on mesh traffic without services.mesh-llm.meshPort.
    '';

    systemd.services.mesh-llm = {
      description = "MeshLLM node";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      # MeshLLM runs hostname to find the node's host name; drop it once
      # https://github.com/Mesh-LLM/mesh-llm/pull/2444 is released.
      # It asks nvidia-smi for the NVIDIA GPUs and their compute capability.
      path = [
        pkgs.hostname
      ]
      ++ lib.optional config.hardware.nvidia.enabled config.hardware.nvidia.package.bin;

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

        # Inference needs the GPU device nodes, so PrivateDevices stays off. There's
        # no DeviceAllow list: the nodes differ between GPUs (Jetsons use nvmap and
        # nvhost), and without one inference silently falls back to the CPU.
        # MeshLLM sizes models by /proc/meminfo (ProcSubset).
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };

  meta = {
    doc = ./mesh-llm.md;
    maintainers = with lib.maintainers; [ kleinbem ];
  };
}
