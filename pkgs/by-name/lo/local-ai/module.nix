{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.local-ai;
  inherit (lib) mkOption types;
in
{
  options.services.local-ai = {
    enable = lib.mkEnableOption "Enable service";

    package = lib.mkPackageOption pkgs "local-ai" { };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    port = mkOption {
      type = types.port;
      default = 8080;
    };

    threads = mkOption {
      type = types.int;
      default = 1;
    };

    models = mkOption {
      type = types.either types.package types.str;
      default = "models";
    };

    parallelRequests = mkOption {
      type = types.int;
      default = 1;
    };

    logLevel = mkOption {
      type = types.enum [
        "error"
        "warn"
        "info"
        "debug"
        "trace"
      ];
      default = "warn";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.local-ai = {
      wantedBy = [ "multi-user.target" ];
      environment.LLAMACPP_PARALLEL = toString cfg.parallelRequests;
      serviceConfig = {
        DynamicUser = true;
        ExecStart = lib.escapeShellArgs (
          [
            "${cfg.package}/bin/local-ai"
            "--address=:${toString cfg.port}"
            "--threads=${toString cfg.threads}"
            "--localai-config-dir=."
            "--models-path=${cfg.models}"
            "--log-level=${cfg.logLevel}"
          ]
          ++ lib.optional (cfg.parallelRequests > 1) "--parallel-requests"
          ++ cfg.extraArgs
        );
        RuntimeDirectory = "local-ai";
        WorkingDirectory = "%t/local-ai";
      };
    };
  };
}
