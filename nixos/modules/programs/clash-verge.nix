{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.programs.clash-verge = {
    enable = lib.mkEnableOption "Clash Verge";
    package = lib.mkPackageOption pkgs "clash-verge" { };
    autoStart = lib.mkEnableOption "Clash Verge auto launch";
    tunMode = lib.mkEnableOption "Clash Verge TUN mode";
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

      security.wrappers.clash-verge = lib.mkIf cfg.tunMode {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${lib.getExe cfg.package}";
      };
    };

  meta.maintainers = with lib.maintainers; [ zendo ];
}
