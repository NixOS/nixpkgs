{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.bazaar;
in
{
  options.programs.bazaar = {
    enable = lib.mkEnableOption "Bazaar FlatHub store";
    package = lib.mkPackageOption pkgs "bazaar" { };

    # flathub needs to be available for bazaar to work
    enableFlathub = lib.mkEnableOption "FlatHub as a remote for flatpak";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.gvfs.enable = true;
    services.flatpak.enable = lib.mkDefault true;
    systemd.services.flatpak-enable-flathub = lib.mkIf cfg.enableFlathub {
      wantedBy = "graphical.target";
      after = "graphical.target";

      path = [ config.services.flatpak.package ];
      script = "flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo";
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 10;
        StartLimitBurst = 3;
        StartLimitInterval = 10;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ dtomvan ];
}
