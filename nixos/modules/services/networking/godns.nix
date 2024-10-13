{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.godns;

  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;
in
{

  options.services.godns = {
    enable = mkEnableOption "GoDNS Service";

    package = mkPackageOption pkgs "godns" { };

    configPath = mkOption {
      type = types.path;
      description = "Path to the configuration file for godns.";
      example = "/etc/godns/config.json";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.godns = {
      description = "GoDNS Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -c ${cfg.configPath}";
        Restart = "always";
        KillMode = "process";
        RestartSec = "2s";
      };
    };
  };

  meta.maintainers = [ lib.maintainers.michaelvanstraten ];
}
