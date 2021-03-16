# pipewire example session manager.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pipewire.media-session;
  enable32BitAlsaPlugins = cfg.alsa.support32Bit
                           && pkgs.stdenv.isx86_64
                           && pkgs.pkgsi686Linux.pipewire != null;

  prioritizeNativeProtocol = {
    "context.modules" = {
      "libpipewire-module-protocol-native" = {
        _priority = -100;
        _content = null;
      };
    };
  };

  # Use upstream config files passed through spa-json-dump as the base
  # Patched here as necessary for them to work with this module
  defaults = {
    alsa-monitor = (builtins.fromJSON (builtins.readFile ./alsa-monitor.conf.json));
    bluez-monitor = (builtins.fromJSON (builtins.readFile ./bluez-monitor.conf.json));
    media-session = recursiveUpdate (builtins.fromJSON (builtins.readFile ./media-session.conf.json)) prioritizeNativeProtocol;
    v4l2-monitor = (builtins.fromJSON (builtins.readFile ./v4l2-monitor.conf.json));
  };
  # Helpers for generating the pipewire JSON config file
  mkSPAValueString = v:
  if builtins.isList v then "[${lib.concatMapStringsSep " " mkSPAValueString v}]"
  else if lib.types.attrs.check v then
    "{${lib.concatStringsSep " " (mkSPAKeyValue v)}}"
  else if builtins.isString v then "\"${lib.generators.mkValueStringDefault { } v}\""
  else lib.generators.mkValueStringDefault { } v;

  mkSPAKeyValue = attrs: map (def: def.content) (
  lib.sortProperties
    (
      lib.mapAttrsToList
        (k: v: lib.mkOrder (v._priority or 1000) "${lib.escape [ "=" ":" ] k} = ${mkSPAValueString (v._content or v)}")
        attrs
    )
  );

  toSPAJSON = attrs: lib.concatStringsSep "\n" (mkSPAKeyValue attrs);
in {

  meta = {
    maintainers = teams.freedesktop.members;
  };

  ###### interface
  options = {
    services.pipewire.media-session = {
      enable = mkOption {
        type = types.bool;
        default = config.services.pipewire.enable;
        defaultText = "config.services.pipewire.enable";
        description = "Example pipewire session manager";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.pipewire.mediaSession;
        example = literalExample "pkgs.pipewire.mediaSession";
        description = ''
          The pipewire-media-session derivation to use.
        '';
      };

      config = {
        media-session = mkOption {
          type = types.attrs;
          description = ''
            Configuration for the media session core. For details see
            https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/${cfg.package.version}/src/daemon/media-session.d/media-session.conf
          '';
          default = {};
        };

        alsa-monitor = mkOption {
          type = types.attrs;
          description = ''
            Configuration for the alsa monitor. For details see
            https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/${cfg.package.version}/src/daemon/media-session.d/alsa-monitor.conf
          '';
          default = {};
        };

        bluez-monitor = mkOption {
          type = types.attrs;
          description = ''
            Configuration for the bluez5 monitor. For details see
            https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/${cfg.package.version}/src/daemon/media-session.d/bluez-monitor.conf
          '';
          default = {};
        };

        v4l2-monitor = mkOption {
          type = types.attrs;
          description = ''
            Configuration for the V4L2 monitor. For details see
            https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/${cfg.package.version}/src/daemon/media-session.d/v4l2-monitor.conf
          '';
          default = {};
        };
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    systemd.user.services.pipewire-media-session.wantedBy = [ "pipewire.service" ];

    environment.etc."pipewire/media-session.d/media-session.conf" = { text = toSPAJSON (recursiveUpdate defaults.media-session cfg.config.media-session); };
    environment.etc."pipewire/media-session.d/v4l2-monitor.conf" = { text = toSPAJSON (recursiveUpdate defaults.v4l2-monitor cfg.config.v4l2-monitor); };

    environment.etc."pipewire/media-session.d/with-alsa" = mkIf config.services.pipewire.alsa.enable { text = ""; };
    environment.etc."pipewire/media-session.d/alsa-monitor.conf" = mkIf config.services.pipewire.alsa.enable { text = toSPAJSON (recursiveUpdate defaults.alsa-monitor cfg.config.alsa-monitor); };

    environment.etc."pipewire/media-session.d/with-pulseaudio" = mkIf config.services.pipewire.pulse.enable { text = ""; };
    environment.etc."pipewire/media-session.d/bluez-monitor.conf" = mkIf config.services.pipewire.pulse.enable { text = toSPAJSON (recursiveUpdate defaults.bluez-monitor cfg.config.bluez-monitor); };

    environment.etc."pipewire/media-session.d/with-jack" = mkIf config.services.pipewire.jack.enable { text = ""; };
  };
}
