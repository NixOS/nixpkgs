{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.ayatana-indicators;
in
{
  options.services.ayatana-indicators = {
    enable = lib.mkEnableOption ''
      Ayatana Indicators, a continuation of Canonical's Application Indicators
    '';

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "with pkgs; [ ayatana-indicator-messages ]";
      description = ''
        List of packages containing Ayatana Indicator services
        that should be brought up by the SystemD "ayatana-indicators" user target.

        Packages specified here must have passthru.ayatana-indicators set correctly.

        If, how, and where these indicators are displayed will depend on your DE.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = cfg.packages;

      pathsToLink = [
        "/share/ayatana"
      ];
    };

    # libayatana-common's ayatana-indicators.target with explicit Wants & Before to bring up requested indicator services
    systemd.user.targets."ayatana-indicators" =
      let
        indicatorServices = lib.lists.flatten (
          map (pkg: (map (ind: "${ind}.service") pkg.passthru.ayatana-indicators)) cfg.packages
        );
      in
      {
        description = "Target representing the lifecycle of the Ayatana Indicators. Each indicator should be bound to it in its individual service file";
        partOf = [ "graphical-session.target" ];
        wants = indicatorServices;
        before = indicatorServices;
      };
  };

  meta.maintainers = with lib.maintainers; [ OPNA2608 ];
}
