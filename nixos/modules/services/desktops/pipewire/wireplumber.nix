{ config, lib, pkgs, ... }:

let
  pwCfg = config.services.pipewire;
  cfg = pwCfg.wireplumber;
  pwUsedForAudio = pwCfg.audio.enable;
in
{
  meta.maintainers = [ lib.maintainers.k900 ];

  options = {
    services.pipewire.wireplumber = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.services.pipewire.enable;
        defaultText = lib.literalExpression "config.services.pipewire.enable";
        description = lib.mdDoc "Whether to enable Wireplumber, a modular session / policy manager for PipeWire";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.wireplumber;
        defaultText = lib.literalExpression "pkgs.wireplumber";
        description = lib.mdDoc "The wireplumber derivation to use.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.hardware.bluetooth.hsphfpd.enable;
        message = "Using Wireplumber conflicts with hsphfpd, as it provides the same functionality. `hardware.bluetooth.hsphfpd.enable` needs be set to false";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    environment.etc."wireplumber/main.lua.d/80-nixos.lua" = lib.mkIf (!pwUsedForAudio) {
      text = ''
        -- Pipewire is not used for audio, so prevent it from grabbing audio devices
        alsa_monitor.enable = function() end
      '';
    };
    environment.etc."wireplumber/main.lua.d/80-systemwide.lua" = lib.mkIf config.services.pipewire.systemWide {
      text = ''
        -- When running system-wide, these settings need to be disabled (they
        -- use functions that aren't available on the system dbus).
        alsa_monitor.properties["alsa.reserve"] = false
        default_access.properties["enable-flatpak-portal"] = false
      '';
    };
    environment.etc."wireplumber/bluetooth.lua.d/80-systemwide.lua" = lib.mkIf config.services.pipewire.systemWide {
      text = ''
        -- When running system-wide, logind-integration needs to be disabled.
        bluez_monitor.properties["with-logind"] = false
      '';
    };

    systemd.packages = [ cfg.package ];

    systemd.services.wireplumber.enable = config.services.pipewire.systemWide;
    systemd.user.services.wireplumber.enable = !config.services.pipewire.systemWide;

    systemd.services.wireplumber.wantedBy = [ "pipewire.service" ];
    systemd.user.services.wireplumber.wantedBy = [ "pipewire.service" ];

    systemd.services.wireplumber.environment = lib.mkIf config.services.pipewire.systemWide {
      # Force wireplumber to use system dbus.
      DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/dbus/system_bus_socket";
    };
  };
}
