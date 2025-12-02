{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.kafka;
  inherit (lib)
    mkIf
    mkOption
    mkMerge
    types
    concatStringsSep
    ;
in
{
  port = 8080;

  extraOpts = {
    package = lib.mkPackageOption pkgs "kminion" { };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = ''
        File containing the credentials to access the repository, in the
        format of an EnvironmentFile as described by systemd.exec(5)
      '';
    };
  };
  serviceOpts = mkMerge (
    [
      {
        serviceConfig = {
          ExecStart = ''
            ${lib.getExe cfg.package}
          '';
          EnvironmentFile = mkIf (cfg.environmentFile != null) cfg.environmentFile;
          RestartSec = "5s";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
          ];
        };
      }
    ]
    ++ [
      (mkIf config.services.apache-kafka.enable {
        after = [ "apache-kafka.service" ];
        requires = [ "apache-kafka.service" ];
      })
    ]
  );
}
