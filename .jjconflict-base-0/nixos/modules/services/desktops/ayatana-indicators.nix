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
        that should be brought up by a SystemD "ayatana-indicators" user target.

        Packages specified here must have passthru.ayatana-indicators set correctly.

        If, how, and where these indicators are displayed will depend on your DE.
        Which target they will be brought up by depends on the packages' passthru.ayatana-indicators.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = cfg.packages;

      pathsToLink = [ "/share/ayatana" ];
    };

    # libayatana-common's ayatana-indicators.target with explicit Wants & Before to bring up requested indicator services
    systemd.user.targets =
      let
        namesToServices = map (indicator: "${indicator}.service");
        indicatorServices =
          target:
          lib.lists.flatten (
            map (
              pkg:
              if lib.isList pkg.passthru.ayatana-indicators then
                # Old format, add to every target
                (lib.warn "${pkg.name} is using the old passthru.ayatana-indicators format, please update it!" (
                  namesToServices pkg.passthru.ayatana-indicators
                ))
              else
                # New format, filter by target being mentioned
                (namesToServices (
                  builtins.filter (
                    service:
                    builtins.any (
                      targetPrefix: "${targetPrefix}-indicators" == target
                    ) pkg.passthru.ayatana-indicators.${service}
                  ) (builtins.attrNames pkg.passthru.ayatana-indicators)
                ))
            ) cfg.packages
          );
      in
      lib.attrsets.mapAttrs
        (name: desc: {
          description = "Target representing the lifecycle of the ${desc}. Each indicator should be bound to it in its individual service file";
          partOf = [ "graphical-session.target" ];
          wants = indicatorServices name;
          before = indicatorServices name;
        })
        {
          ayatana-indicators = "Ayatana Indicators";
          lomiri-indicators = "Ayatana/Lomiri Indicators that shall be run in Lomiri";
        };
  };

  meta.maintainers = with lib.maintainers; [ OPNA2608 ];
}
