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
    enable = lib.mkEnableOption "Bezel trackpad gesture daemon" // {
      description = ''
        Whether to enable the Bezel trackpad gesture daemon as a systemd user service.
        It starts only for users in the `input` and `uinput` groups, which can be
        granted through {option}`users.users.<name>.extraGroups`.
      '';
    };

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
        ]
      '';
      example = lib.literalExpression ''
        with pkgs; [
          pulseaudio
          light
          mpc
        ]
      '';
      description = ''
        Extra packages to add to the systemd unit's PATH, in front of the system
        and per-user profiles.  By default, it includes the packages required by the
        [default configuration](https://github.com/Indra55/bezel/blob/main/config.toml.example)
        except Hyprland, which is expected to come from the system profile.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.bezel = {
      description = "Bezel Trackpad Gestures";
      after = [ "graphical-session.target" ];
      wantedBy = [ "default.target" ];
      # Skip users who cannot read the trackpad instead of restarting forever
      unitConfig.ConditionGroup = [
        "input"
        "uinput"
      ];
      serviceConfig = {
        ExecStart = lib.getExe cfg.package;
        Restart = "always";
        RestartSec = 3;
      };
      # Unit PATH replaces the user manager's, so keep profile commands such as hyprctl reachable
      path = cfg.extraPackages ++ [
        "/run/wrappers"
        "%h/.nix-profile"
        "%h/.local/state/nix/profile"
        "/etc/profiles/per-user/%u"
        "/nix/var/nix/profiles/default"
        "/run/current-system/sw"
      ];
    };

    hardware.uinput.enable = true;
  };

  meta.maintainers = with lib.maintainers; [
    olimoli
    yiyu
  ];
}
