{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.storagebox;
  inherit (lib) mkPackageOption;
in
{
  port = 9509;
  extraOpts = {
    package = mkPackageOption pkgs "prometheus-storagebox-exporter" { };
    tokenFile = lib.mkOption {
      type = lib.types.pathWith {
        inStore = false;
        absolute = true;
      };
      description = "File that contains the Hetzner API token to use.";
    };

  };
  serviceOpts = {
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    script = ''
      export HETZNER_TOKEN=$(< "''${CREDENTIALS_DIRECTORY}/token")
      exec ${lib.getExe cfg.package}
    '';

    environment = {
      LISTEN_ADDR = "${toString cfg.listenAddress}:${toString cfg.port}";
    };

    serviceConfig = {
      DynamicUser = true;
      Restart = "always";
      RestartSec = "10s";
      LoadCredential = [
        "token:${cfg.tokenFile}"
      ];
    };
  };
}
