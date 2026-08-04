{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.text-embeddings-inference;
  inherit (lib)
    escapeShellArgs
    getExe
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    optional
    types
    ;
in
{
  options.services.text-embeddings-inference = {
    enable = mkEnableOption "Hugging Face Text Embeddings Inference server";

    package = mkPackageOption pkgs "text-embeddings-inference" { };

    modelId = mkOption {
      type = types.str;
      example = "BAAI/bge-base-en-v1.5";
      description = ''
        Hugging Face model id, or local path to a model directory, to serve. See
        <https://huggingface.co/models?other=text-embeddings-inference> for
        compatible models.
      '';
    };

    hostname = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "Address to listen on.";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Port to listen on.";
    };

    environmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "/run/secrets/text-embeddings-inference.env";
      description = ''
        Path to an environment file loaded by the service. Use it to provide
        `HF_TOKEN` for gated/private models, e.g.:

        ```
        HF_TOKEN=hf_xxx
        ```

        An environment file is used instead of {manpage}`systemd.exec(5)`
        `LoadCredential=` because the server reads `HF_TOKEN` directly from the
        process environment.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra command-line arguments passed to `text-embeddings-router`
        (for example `--pooling`, `--dtype`, `--max-batch-tokens`). See
        `text-embeddings-router --help`.
      '';
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to open the firewall for the configured port.

        The server has no built-in authentication, so only enable this when
        access is otherwise restricted (e.g. bound to `127.0.0.1`, or placed
        behind an authenticating reverse proxy).
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.text-embeddings-inference = {
      description = "Hugging Face Text Embeddings Inference server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      environment.HF_HOME = "/var/lib/text-embeddings-inference";

      serviceConfig = {
        Type = "exec";
        DynamicUser = true;
        ExecStart = escapeShellArgs (
          [
            (getExe cfg.package)
            "--model-id"
            cfg.modelId
            "--hostname"
            cfg.hostname
            "--port"
            (toString cfg.port)
          ]
          ++ cfg.extraArgs
        );
        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
        StateDirectory = "text-embeddings-inference";
        WorkingDirectory = "/var/lib/text-embeddings-inference";

        CapabilityBoundingSet = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
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
        SystemCallFilter = [ "@system-service" ];
        UMask = "0077";
      };
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };

  meta.maintainers = [ lib.maintainers.gdifolco ];
}
