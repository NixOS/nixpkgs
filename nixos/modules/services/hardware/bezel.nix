{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bezel;
in
{
  options.services.bezel = {
    enable = lib.mkEnableOption "Bezel trackpad gesture daemon";

    package = lib.mkPackageOption pkgs "bezel" { };

    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = with pkgs; [
        wireplumber
        brightnessctl
        playerctl
      ];
      defaultText = lib.literalExpression ''
        with pkgs; [
          wireplumber
          brightnessctl
          playerctl
        ];
      '';
      example = lib.literalExpression ''
        with pkgs; [
          pulseaudio
          light
          mpc
        ];
      '';
      description = ''
        Extra packages to install system-wide and add to the systemd unit's PATH.
        By default, it includes packages required by the [default configuration](https://github.com/Indra55/bezel/blob/main/config.toml.example)
        except Hyprland.
      '';
    };
  };

  config = {
    environment.systemPackages = lib.optional (cfg.enable && cfg.package != null) cfg.package;

    systemd.user.services.bezel = lib.mkIf cfg.enable {
      description = "Bezel Trackpad Gestures";
      after = [ "graphical-session.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "always";
        RestartSec = 3;
      };
      path = [ pkgs.bash ] ++ cfg.extraPackages;
    };

    hardware.uinput.enable = lib.mkIf cfg.enable true;
  };

  meta.maintainers = with lib.maintainers; [
    olimoli
    yiyu
  ];
}
