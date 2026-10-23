{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.any2nix-api;
in
{
  meta.maintainers = with lib.maintainers; [
    gbr-ufs
  ];
  options.services.any2nix-api = {
    enable = lib.mkEnableOption "any2nix-api, a JSON-based API for translating from different formats to Nix.";
    package = lib.mkPackageOption pkgs "any2nix-api" { };
    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = ''
        The IP address on which any2nix-api listens.
      '';
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      example = 8080;
      description = ''
        The port on which any2nix-api listens.
      '';
    };
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/run/secrets/any2nix-api.env";
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)` to be passed to the service.
      '';
    };
    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        RUST_LOG = "debug";
      };
      description = ''
        Extra environment variables to pass to the any2nix-api service.
      '';
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open the firewall for any2nix-api.
      '';
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.any2nix-api = {
      description = "any2nix-api service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      environment = {
        ANY2NIX_API_HOST = cfg.address;
        ANY2NIX_API_PORT = toString cfg.port;
      }
      // cfg.extraEnvironment;
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        Restart = "on-failure";
        RestartSec = "5s";
        DynamicUser = true;
      };
    };
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
