{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.llama-cpp;
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "llama-cpp" "host" ]
      [ "services" "llama-cpp" "settings" "host" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "llama-cpp" "port" ]
      [ "services" "llama-cpp" "settings" "port" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "llama-cpp" "model" ]
      [ "services" "llama-cpp" "settings" "model" ]
    )
    (lib.mkRenamedOptionModule
      [ "services" "llama-cpp" "modelsDir" ]
      [ "services" "llama-cpp" "settings" "models-dir" ]
    )
    (lib.mkRemovedOptionModule [ "services" "llama-cpp" "modelsPreset" ] ''
      Using a Nix attribute set for configuring model presets is no longer
      supported. However, it's possible to use
      `services.llama-cpp.settings.models-preset` to provide a path to an INI
      file with desired options.
    '')
    (lib.mkRemovedOptionModule [
      "services"
      "llama-cpp"
      "extraFlags"
    ] "Use `services.llama-cpp.settings` instead")
  ];

  options = {
    services.llama-cpp = {
      enable = lib.mkEnableOption "llama.cpp HTTP server";

      package = lib.mkPackageOption pkgs "llama-cpp" { };

      modelLoader = {
        enable = lib.mkEnableOption "the llama.cpp model loader";

        models = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          example = [
            "bartowski/Llama-3.2-1B-Instruct-GGUF:Q4_K_M"
            "ggml-org/gemma-3-1b-it-GGUF"
          ];
          description = ''
            Models to download using llama.cpp before the services listed in
            {option}`services.llama-cpp.modelLoader.wantedBy` start.

            Models use llama.cpp's `<user>/<model>[:quant]` Hugging Face format
            and are stored in {file}`/var/cache/llama-cpp`. The quantization is
            optional and defaults to `Q4_K_M` when available. The model loader
            does not require {option}`services.llama-cpp.enable`.
          '';
        };

        wantedBy = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "llama-cpp.service" ];
          example = [
            "llama-cpp.service"
            "llama-swap.service"
          ];
          description = ''
            Systemd units that pull in `llama-cpp-model-loader.service` and wait
            for the configured models to be downloaded before starting.
          '';
        };
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = lib.types.attrs;
          options = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              example = "0.0.0.0";
              description = ''
                IP address on which the server should listen on.
              '';
            };

            port = lib.mkOption {
              type = lib.types.port;
              default = 8080;
              example = 1337;
              description = ''
                Port on which the server should listen on.
              '';
            };
          };
        };
        default = { };
        example = {
          host = "0.0.0.0";
          port = 1337;
          model = "/mnt/llms/Foo3.6-27B-UD-Q4_K_XL.gguf";
          ctx-size = 252144;
          temp = 0.6;
          top-k = 20;
          top-p = 0.95;
          batch-size = 512;
          ubatch-size = 256;
          spec-type = "draft-mtp";
          spec-draft-n-max = 2;
          flash-attn = "on";
        };
        description = ''
          Command-line arguments for `llama-server`.

          See <https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md>
          for the full list of options.
        '';
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the server.
        '';
      };
    };
  };

  config = {
    systemd.services.llama-cpp = lib.mkIf cfg.enable {
      description = "llama.cpp HTTP server";
      wants = [ "network.target" ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = toString [
          (lib.getExe' cfg.package "llama-server")
          (lib.cli.toCommandLine (optionName: {
            option = if builtins.stringLength optionName > 1 then "--${optionName}" else "-${optionName}";
            sep = " ";
            explicitBool = false;
            formatArg = lib.generators.mkValueStringDefault { };
          }) cfg.settings)
        ];
        ExecReload = "${lib.getExe' pkgs.coreutils "kill"} -HUP $MAINPID";
        Restart = "on-failure";
        RestartSec = 300;

        DynamicUser = true;
        StateDirectory = "llama-cpp";
        CacheDirectory = "llama-cpp";
        WorkingDirectory = "/var/lib/${config.systemd.services.llama-cpp.serviceConfig.StateDirectory}";
        Environment = [
          "LLAMA_CACHE=/var/cache/${config.systemd.services.llama-cpp.serviceConfig.CacheDirectory}"
        ];

        AmbientCapabilities = [ "" ];
        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = false; # Required for GPU support.
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
      };
    };

    systemd.services.llama-cpp-model-loader = lib.mkIf cfg.modelLoader.enable {
      description = "Download llama.cpp models";
      wantedBy = cfg.modelLoader.wantedBy;
      before = cfg.modelLoader.wantedBy;
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      script = lib.concatMapStringsSep "\n" (
        model: "${lib.getExe cfg.package} download --hf-repo ${lib.escapeShellArg model}"
      ) cfg.modelLoader.models;

      serviceConfig = {
        Type = "oneshot";
        DynamicUser = true;
        CacheDirectory = "llama-cpp";
        Environment = [
          "LLAMA_CACHE=/var/cache/${config.systemd.services.llama-cpp-model-loader.serviceConfig.CacheDirectory}"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.enable (
      lib.optional cfg.openFirewall cfg.settings.port
    );
  };

  meta.maintainers = with lib.maintainers; [
    azahi
    newam
  ];
}
