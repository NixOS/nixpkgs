# pipewire example session manager.
{ config, lib, pkgs, ... }:

with lib;

let
  json = pkgs.formats.json {};
  cfg = config.services.pipewire.media-session;
  enable32BitAlsaPlugins = cfg.alsa.support32Bit
                           && pkgs.stdenv.isx86_64
                           && pkgs.pkgsi686Linux.pipewire != null;

  # Use upstream config files passed through spa-json-dump as the base
  # Patched here as necessary for them to work with this module
  defaults = {
    alsa-monitor = lib.importJSON ./media-session/alsa-monitor.conf.json;
    bluez-monitor = lib.importJSON ./media-session/bluez-monitor.conf.json;
    media-session = lib.importJSON ./media-session/media-session.conf.json;
    v4l2-monitor = lib.importJSON ./media-session/v4l2-monitor.conf.json;
  };

  configs = {
    alsa-monitor = recursiveUpdate defaults.alsa-monitor cfg.config.alsa-monitor;
    bluez-monitor = recursiveUpdate defaults.bluez-monitor cfg.config.bluez-monitor;
    media-session = recursiveUpdate defaults.media-session cfg.config.media-session;
    v4l2-monitor = recursiveUpdate defaults.v4l2-monitor cfg.config.v4l2-monitor;
  };
in {

  meta = {
    maintainers = teams.freedesktop.members;
    # uses attributes of the linked package
    buildDocsInSandbox = false;
  };

  ###### interface
  options = {
    services.pipewire.media-session = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Whether to enable the deprecated example Pipewire session manager";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.pipewire-media-session;
        defaultText = literalExpression "pkgs.pipewire-media-session";
        description = lib.mdDoc ''
          The pipewire-media-session derivation to use.
        '';
      };

      config = {
        media-session = mkOption {
          type = json.type;
          description = lib.mdDoc ''
            Configuration for the media session core. For details see
            https://gitlab.freedesktop.org/pipewire/media-session/-/blob/${cfg.package.version}/src/daemon/media-session.d/media-session.conf
          '';
          default = defaults.media-session;
        };

        alsa-monitor = mkOption {
          type = json.type;
          description = lib.mdDoc ''
            Configuration for the alsa monitor. For details see
            https://gitlab.freedesktop.org/pipewire/media-session/-/blob/${cfg.package.version}/src/daemon/media-session.d/alsa-monitor.conf
          '';
          default = defaults.alsa-monitor;
        };

        bluez-monitor = mkOption {
          type = json.type;
          description = lib.mdDoc ''
            Configuration for the bluez5 monitor. For details see
            https://gitlab.freedesktop.org/pipewire/media-session/-/blob/${cfg.package.version}/src/daemon/media-session.d/bluez-monitor.conf
          '';
          default = defaults.bluez-monitor;
        };

        v4l2-monitor = mkOption {
          type = json.type;
          description = lib.mdDoc ''
            Configuration for the V4L2 monitor. For details see
            https://gitlab.freedesktop.org/pipewire/media-session/-/blob/${cfg.package.version}/src/daemon/media-session.d/v4l2-monitor.conf
          '';
          default = defaults.v4l2-monitor;
        };
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    # Enable either system or user units.
    systemd.services.pipewire-media-session.enable = config.services.pipewire.systemWide;
    systemd.user.services.pipewire-media-session.enable = !config.services.pipewire.systemWide;

    systemd.services.pipewire-media-session.wantedBy = [ "pipewire.service" ];
    systemd.user.services.pipewire-media-session.wantedBy = [ "pipewire.service" ];

    environment.etc."pipewire/media-session.d/media-session.conf" = {
      source = json.generate "media-session.conf" configs.media-session;
    };
    environment.etc."pipewire/media-session.d/v4l2-monitor.conf" = {
      source = json.generate "v4l2-monitor.conf" configs.v4l2-monitor;
    };

    environment.etc."pipewire/media-session.d/with-audio" =
      mkIf config.services.pipewire.audio.enable {
        text = "";
      };

    environment.etc."pipewire/media-session.d/with-alsa" =
      mkIf config.services.pipewire.alsa.enable {
        text = "";
      };
    environment.etc."pipewire/media-session.d/alsa-monitor.conf" =
      mkIf config.services.pipewire.alsa.enable {
        source = json.generate "alsa-monitor.conf" configs.alsa-monitor;
      };

    environment.etc."pipewire/media-session.d/with-pulseaudio" =
      mkIf config.services.pipewire.pulse.enable {
        text = "";
      };
    environment.etc."pipewire/media-session.d/bluez-monitor.conf" =
      mkIf config.services.pipewire.pulse.enable {
        source = json.generate "bluez-monitor.conf" configs.bluez-monitor;
      };

    environment.etc."pipewire/media-session.d/with-jack" =
      mkIf config.services.pipewire.jack.enable {
        text = "";
      };
  };
}
