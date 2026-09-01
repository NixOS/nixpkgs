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

  config = lib.mkIf cfg.enable {
    systemd.services.llama-cpp = {
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
        WorkingDirectory = "/var/lib/llama-cpp";
        Environment = [ "LLAMA_CACHE=/var/cache/llama-cpp" ];

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

    networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.settings.port;
  };

  meta.maintainers = with lib.maintainers; [
    azahi
    newam
  ];
}
