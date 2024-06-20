{ config, lib, pkgs, ... }:
let
  inherit (lib) types;

  cfg = config.services.ollama;
  ollamaPackage = cfg.package.override {
    inherit (cfg) acceleration;
    linuxPackages = config.boot.kernelPackages // {
      nvidia_x11 = config.hardware.nvidia.package;
    };
  };
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "ollama" "listenAddress" ]
      "Use `services.ollama.host` and `services.ollama.port` instead.")
  ];

  options = {
    services.ollama = {
      enable = lib.mkEnableOption "ollama server for local large language models";
      package = lib.mkPackageOption pkgs "ollama" { };
      home = lib.mkOption {
        type = types.str;
        default = "%S/ollama";
        example = "/home/foo";
        description = ''
          The home directory that the ollama service is started in.

          See also `services.ollama.writablePaths` and `services.ollama.sandbox`.
        '';
      };
      models = lib.mkOption {
        type = types.str;
        default = "%S/ollama/models";
        example = "/path/to/ollama/models";
        description = ''
          The directory that the ollama service will read models from and download new models to.

          See also `services.ollama.writablePaths` and `services.ollama.sandbox`
          if downloading models or other mutation of the filesystem is required.
        '';
      };
      sandbox = lib.mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Whether to enable systemd's sandboxing capabilities.

          This sets [`DynamicUser`](
          https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#DynamicUser=
          ), which runs the server as a unique user with read-only access to most of the filesystem.

          See also `services.ollama.writablePaths`.
        '';
      };
      writablePaths = lib.mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "/home/foo" "/mnt/foo" ];
        description = ''
          Paths that the server should have write access to.

          This sets [`ReadWritePaths`](
          https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ReadWritePaths=
          ), which allows specified paths to be written to through the default sandboxing.

          See also `services.ollama.sandbox`.
        '';
      };
      host = lib.mkOption {
        type = types.str;
        default = "127.0.0.1";
        example = "0.0.0.0";
        description = ''
          The host address which the ollama server HTTP interface listens to.
        '';
      };
      port = lib.mkOption {
        type = types.port;
        default = 11434;
        example = 11111;
        description = ''
          Which port the ollama server listens to.
        '';
      };
      acceleration = lib.mkOption {
        type = types.nullOr (types.enum [ false "rocm" "cuda" ]);
        default = null;
        example = "rocm";
        description = ''
          What interface to use for hardware acceleration.

          - `null`: default behavior
            - if `nixpkgs.config.rocmSupport` is enabled, uses `"rocm"`
            - if `nixpkgs.config.cudaSupport` is enabled, uses `"cuda"`
            - otherwise defaults to `false`
          - `false`: disable GPU, only use CPU
          - `"rocm"`: supported by most modern AMD GPUs
          - `"cuda"`: supported by most modern NVIDIA GPUs
        '';
      };
      environmentVariables = lib.mkOption {
        type = types.attrsOf types.str;
        default = { };
        example = {
          OLLAMA_LLM_LIBRARY = "cpu";
          HIP_VISIBLE_DEVICES = "0,1";
        };
        description = ''
          Set arbitrary environment variables for the ollama service.

          Be aware that these are only seen by the ollama server (systemd service),
          not normal invocations like `ollama run`.
          Since `ollama run` is mostly a shell around the ollama server, this is usually sufficient.
        '';
      };
      openFirewall = lib.mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open the firewall for ollama.
          This adds `services.ollama.port` to `networking.firewall.allowedTCPPorts`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.ollama = {
      description = "Server for local large language models";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = cfg.environmentVariables // {
        HOME = cfg.home;
        OLLAMA_MODELS = cfg.models;
        OLLAMA_HOST = "${cfg.host}:${toString cfg.port}";
      };
      serviceConfig = {
        ExecStart = "${lib.getExe ollamaPackage} serve";
        WorkingDirectory = cfg.home;
        StateDirectory = [ "ollama" ];
        DynamicUser = cfg.sandbox;
        ReadWritePaths = cfg.writablePaths;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };

    environment.systemPackages = [ ollamaPackage ];
  };

  meta.maintainers = with lib.maintainers; [ abysssol onny ];
}
