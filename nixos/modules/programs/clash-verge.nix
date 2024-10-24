{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.programs.clash-verge = {
    enable = lib.mkEnableOption "Clash Verge";
    package = lib.mkOption {
      type = lib.types.package;
      description = ''
        The clash-verge package to use. Available options are
        clash-verge-rev and clash-nyanpasu, both are forks of
        the original clash-verge project.
      '';
      example = "pkgs.clash-verge-rev";
    };
    autoStart = lib.mkEnableOption "Clash Verge auto launch";
    serviceModule = lib.mkEnableOption "Clash Verge Service mode";
  };

  config =
    let
      cfg = config.programs.clash-verge;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages = [
        cfg.package
        (lib.mkIf cfg.autoStart (
          pkgs.makeAutostartItem {
            name = "clash-verge";
            package = cfg.package;
          }
        ))
      ];

      systemd.services.clash-verge = lib.mkIf cfg.serviceModule {
        enable = true;
        Restart = "on-failure";
        description = "Clash Verge Service Mode";
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/clash-verge-service";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };

  meta.maintainers = with lib.maintainers; [ zendo ];
}
