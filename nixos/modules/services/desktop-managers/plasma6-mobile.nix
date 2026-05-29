{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.desktopManager.plasma6.mobile;
  inherit (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  inherit (pkgs) kdePackages;
in
{
  options.services.desktopManager.plasma6.mobile = {
    enable = mkEnableOption "Plasma Mobile shell (Plasma 6)";
  };

  options.environment.plasma6.mobile.excludePackages = mkOption {
    description = "List of Plasma Mobile packages to exclude from the default installation.";
    type = types.listOf types.package;
    default = [ ];
    example = lib.literalExpression "[ pkgs.kdePackages.kclock ]";
  };

  config = mkIf cfg.enable {
    services.desktopManager.plasma6.enable = mkDefault true;

    # plasmashell crashes without a PulseAudio-compatible sound server.
    warnings =
      lib.optionals
        (
          !(
            config.services.pulseaudio.enable
            || (config.services.pipewire.enable && config.services.pipewire.pulse.enable)
          )
        )
        [
          ''
            Plasma Mobile requires a PulseAudio-compatible sound server.
            Without one, plasmashell will crash on startup.
            Enable services.pipewire with services.pipewire.pulse.enable = true,
            or enable services.pulseaudio.
          ''
        ];

    services.pipewire.enable = mkDefault true;
    services.pipewire.pulse.enable = mkDefault true;

    environment.systemPackages =
      let
        requiredPackages = with kdePackages; [
          plasma-mobile
          plasma-keyboard # .desktop file referenced by envmanager's kwinrc InputMethod
        ];
        optionalPackages = with kdePackages; [
          alligator
          audiotube
          calindori
          kalk
          kasts
          kclock
          keysmith
          koko
          kongress
          krecorder
          ktrip
          kweather
          plasma-dialer
          qmlkonsole
          spacebar
        ];
      in
      requiredPackages
      ++ utils.removePackagesByName optionalPackages config.environment.plasma6.mobile.excludePackages;

    services.displayManager = {
      sessionPackages = [ kdePackages.plasma-mobile ];
      defaultSession = lib.mkOverride 900 "plasma-mobile";
    };
    services.displayManager.sddm.settings.General.InputMethod = mkDefault "qtvirtualkeyboard";

    hardware.bluetooth.enable = mkDefault true;
    networking.networkmanager.enable = mkDefault true;
    hardware.sensor.iio.enable = mkDefault true;
  };
  meta.maintainers = with lib.maintainers; [ leuflatworm ];
}
