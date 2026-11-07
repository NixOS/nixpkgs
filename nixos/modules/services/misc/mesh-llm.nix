{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.mesh-llm;

  settingsFormat = pkgs.formats.toml { };
  # Each package in `plugins` becomes a `[[plugin]]` entry. An entry with the
  # same name in `settings.plugin` is merged into it, so per-plugin settings
  # such as `url` stay in `settings`.
  pluginName =
    p:
    p.pluginName
      or (throw "services.mesh-llm.plugins: ${lib.getName p} has no passthru.pluginName; add it as a [[plugin]] entry in services.mesh-llm.settings instead");
  manualPlugins = cfg.settings.plugin or [ ];
  manualPlugin = name: lib.findFirst (entry: (entry.name or null) == name) { } manualPlugins;
  packagedPlugins = map (
    p:
    {
      name = pluginName p;
      command = lib.getExe p;
    }
    // manualPlugin (pluginName p)
  ) cfg.plugins;
  packagedNames = map pluginName cfg.plugins;
  finalSettings =
    cfg.settings
    // lib.optionalAttrs (cfg.plugins != [ ]) {
      plugin =
        packagedPlugins ++ lib.filter (entry: !(lib.elem (entry.name or null) packagedNames)) manualPlugins;
    };
  configFile = settingsFormat.generate "mesh-llm-config.toml" finalSettings;
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

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.mesh-llmPlugins.openai-endpoint ]";
      description = ''
        Plugin packages to run, such as those in `pkgs.mesh-llmPlugins`.
        Each one becomes a `[[plugin]]` entry in the configuration; settings for
        it go in a `plugin` entry of [](#opt-services.mesh-llm.settings) with the
        same `name`.
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
        [](#opt-services.mesh-llm.environmentFiles) instead.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.externalPath;
      default = [ ];
      example = [ "/run/secrets/mesh-llm.env" ];
      description = ''
        Environment files for secrets, such as `MESH_LLM_JOIN_FILE` pointing to
        a private mesh's invite token, or `HF_TOKEN` for gated models.
      '';
    };

    allowRuntimeDownloads = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether MeshLLM may download prebuilt native runtimes at startup when
        none of the package's runtimes fits the host. Off, it uses only the
        runtimes built by Nix and doesn't fetch its runtime catalog from GitHub.
        On, MeshLLM's own `runtime.native_runtime.download` setting decides,
        which defaults to downloading.
      '';
    };

    ownerKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.externalPath;
      default = null;
      example = "/run/secrets/mesh-llm-owner-keystore.json";
      description = ''
        Owner keystore created with `mesh-llm auth init`. It attests that this
        node belongs to its owner, for meshes that admit only owned nodes
        (`--trust-policy` in [](#opt-services.mesh-llm.extraArgs)), and lets
        the console save configuration. The service reads it as a systemd
        credential and doesn't start if it can't load it. Put the passphrase
        of an encrypted keystore in `MESH_LLM_OWNER_PASSPHRASE` in
        [](#opt-services.mesh-llm.environmentFiles).
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
      # MeshLLM asks nvidia-smi for the NVIDIA GPUs and their compute capability.
      path = lib.optional config.hardware.nvidia.enabled config.hardware.nvidia.package.bin;

      environment = {
        # MeshLLM keeps its identity, configuration and model cache in HOME.
        HOME = "/var/lib/mesh-llm";
      }
      // lib.optionalAttrs (!cfg.allowRuntimeDownloads) {
        # Overrides the runtime.native_runtime.download setting without writing
        # config.toml, so configuration saved in the console is kept.
        MESH_LLM_NO_RUNTIME_DOWNLOAD = "1";
      };

      preStart = lib.optionalString (finalSettings != { }) ''
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
          ++ lib.optionals (cfg.ownerKeyFile != null) [
            "--owner-key"
            "%d/owner-keystore"
            # Fail instead of starting without the owner's attestation.
            "--owner-required"
          ]
          ++ cfg.extraArgs
        );
        EnvironmentFile = cfg.environmentFiles;
        LoadCredential = lib.optional (cfg.ownerKeyFile != null) "owner-keystore:${cfg.ownerKeyFile}";
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
        # MeshLLM sizes models by /proc/meminfo, so ProcSubset stays unset.
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
