{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.checkmate-capture;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkIf
    mkOption
    types
    isPath
    ;
  inherit (builtins) toString;

  assertStringPath =
    optionName: value:
    if isPath value then
      throw ''
        services.checkmate-capture.${optionName}:
          ${toString value}
          is a Nix path, but should be a string, since Nix
          paths are copied into the world-readable Nix store.
      ''
    else
      value;
in
{
  options = {

    services.checkmate-capture = {
      enable = mkEnableOption "Checkmate capture agent";

      package = mkPackageOption pkgs "checkmate-capture" { };

      ginMode = mkOption {
        type = types.enum [
          "release"
          "debug"
        ];
        default = "release";
        description = ''
          The mode of the Gin framework.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 59232;
        description = ''
          The port that the Checkmate capture listens on.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for Checkmate capture.
        '';
      };

      apiSecretFile = mkOption {
        type = types.path;
        apply = assertStringPath "apiSecretFile";
        description = ''
          The full path to a file containing the secret key for the API.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    systemd.services.checkmate-capture = {
      description = "Checkmate capture.";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      startLimitIntervalSec = 60;
      startLimitBurst = 3;
      environment = {
        GIN_MODE = cfg.ginMode;
        PORT = toString cfg.port;
      };
      serviceConfig = {
        LoadCredential = [ "API_SECRET:${cfg.apiSecretFile}" ];
        LimitCORE = 0;
        KillSignal = "SIGINT";
        TimeoutStopSec = "30s";
        Restart = "on-failure";
        DynamicUser = true;
      };
      script = ''
        set -eou pipefail
        shopt -s inherit_errexit

        API_SECRET="$(<"$CREDENTIALS_DIRECTORY/API_SECRET")" ${cfg.package}/bin/capture
      '';
    };
  };
}
