# pipewire service.
{ config, lib, pkgs, ... }:

with lib;

let
  json = pkgs.formats.json {};
  cfg = config.services.pipewire;
  enable32BitAlsaPlugins = cfg.alsa.support32Bit
                           && pkgs.stdenv.isx86_64
                           && pkgs.pkgsi686Linux.pipewire != null;

  # The package doesn't output to $out/lib/pipewire directly so that the
  # overlays can use the outputs to replace the originals in FHS environments.
  #
  # This doesn't work in general because of missing development information.
  jack-libs = pkgs.runCommand "jack-libs" {} ''
    mkdir -p "$out/lib"
    ln -s "${cfg.package.jack}/lib" "$out/lib/pipewire"
  '';

  # Use upstream config files passed through spa-json-dump as the base
  # Patched here as necessary for them to work with this module
  defaults = {
    client = lib.importJSON ./daemon/client.conf.json;
    client-rt = lib.importJSON ./daemon/client-rt.conf.json;
    jack = lib.importJSON ./daemon/jack.conf.json;
    minimal = lib.importJSON ./daemon/minimal.conf.json;
    pipewire = lib.importJSON ./daemon/pipewire.conf.json;
    pipewire-pulse = lib.importJSON ./daemon/pipewire-pulse.conf.json;
  };

  useSessionManager = cfg.wireplumber.enable || cfg.media-session.enable;

  configs = {
    client = recursiveUpdate defaults.client cfg.config.client;
    client-rt = recursiveUpdate defaults.client-rt cfg.config.client-rt;
    jack = recursiveUpdate defaults.jack cfg.config.jack;
    pipewire = recursiveUpdate (if useSessionManager then defaults.pipewire else defaults.minimal) cfg.config.pipewire;
    pipewire-pulse = recursiveUpdate defaults.pipewire-pulse cfg.config.pipewire-pulse;
  };
in {

  meta = {
    maintainers = teams.freedesktop.members;
    # uses attributes of the linked package
    buildDocsInSandbox = false;
  };

  ###### interface
  options = {
    services.pipewire = {
      enable = mkEnableOption "pipewire service";

      package = mkOption {
        type = types.package;
        default = pkgs.pipewire;
        defaultText = literalExpression "pkgs.pipewire";
        description = lib.mdDoc ''
          The pipewire derivation to use.
        '';
      };

      socketActivation = mkOption {
        default = true;
        type = types.bool;
        description = lib.mdDoc ''
          Automatically run pipewire when connections are made to the pipewire socket.
        '';
      };

      config = {
        client = mkOption {
          type = json.type;
          default = {};
          description = lib.mdDoc ''
            Configuration for pipewire clients. For details see
            https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/${cfg.package.version}/src/daemon/client.conf.in
          '';
        };

        client-rt = mkOption {
          type = json.type;
          default = {};
          description = lib.mdDoc ''
            Configuration for realtime pipewire clients. For details see
            https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/${cfg.package.version}/src/daemon/client-rt.conf.in
          '';
        };

        jack = mkOption {
          type = json.type;
          default = {};
          description = lib.mdDoc ''
            Configuration for the pipewire daemon's jack module. For details see
            https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/${cfg.package.version}/src/daemon/jack.conf.in
          '';
        };

        pipewire = mkOption {
          type = json.type;
          default = {};
          description = lib.mdDoc ''
            Configuration for the pipewire daemon. For details see
            https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/${cfg.package.version}/src/daemon/pipewire.conf.in
          '';
        };

        pipewire-pulse = mkOption {
          type = json.type;
          default = {};
          description = lib.mdDoc ''
            Configuration for the pipewire-pulse daemon. For details see
            https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/${cfg.package.version}/src/daemon/pipewire-pulse.conf.in
          '';
        };
      };

      audio = {
        enable = lib.mkOption {
          type = lib.types.bool;
          # this is for backwards compatibility
          default = cfg.alsa.enable || cfg.jack.enable || cfg.pulse.enable;
          defaultText = lib.literalExpression "config.services.pipewire.alsa.enable || config.services.pipewire.jack.enable || config.services.pipewire.pulse.enable";
          description = lib.mdDoc "Whether to use PipeWire as the primary sound server";
        };
      };

      alsa = {
        enable = mkEnableOption "ALSA support";
        support32Bit = mkEnableOption "32-bit ALSA support on 64-bit systems";
      };

      jack = {
        enable = mkEnableOption "JACK audio emulation";
      };

      pulse = {
        enable = mkEnableOption "PulseAudio server emulation";
      };

      systemWide = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = lib.mdDoc ''
          If true, a system-wide PipeWire service and socket is enabled
          allowing all users in the "pipewire" group to use it simultaneously.
          If false, then user units are used instead, restricting access to
          only one user.

          Enabling system-wide PipeWire is however not recommended and disabled
          by default according to
          https://github.com/PipeWire/pipewire/blob/master/NEWS
        '';
      };

    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.audio.enable -> !config.hardware.pulseaudio.enable;
        message = "Using PipeWire as the sound server conflicts with PulseAudio. This option requires `hardware.pulseaudio.enable` to be set to false";
      }
      {
        assertion = cfg.jack.enable -> !config.services.jack.jackd.enable;
        message = "PipeWire based JACK emulation doesn't use the JACK service. This option requires `services.jack.jackd.enable` to be set to false";
      }
      {
        # JACK intentionally not checked, as PW-on-JACK setups are a thing that some people may want
        assertion = (cfg.alsa.enable || cfg.pulse.enable) -> cfg.audio.enable;
        message = "Using PipeWire's ALSA/PulseAudio compatibility layers requires running PipeWire as the sound server. Set `services.pipewire.audio.enable` to true.";
      }
    ];

    environment.systemPackages = [ cfg.package ]
                                 ++ lib.optional cfg.jack.enable jack-libs;

    systemd.packages = [ cfg.package ]
                       ++ lib.optional cfg.pulse.enable cfg.package.pulse;

    # PipeWire depends on DBUS but doesn't list it. Without this booting
    # into a terminal results in the service crashing with an error.
    systemd.services.pipewire.bindsTo = [ "dbus.service" ];
    systemd.user.services.pipewire.bindsTo = [ "dbus.service" ];

    # Enable either system or user units.  Note that for pipewire-pulse there
    # are only user units, which work in both cases.
    systemd.sockets.pipewire.enable = cfg.systemWide;
    systemd.services.pipewire.enable = cfg.systemWide;
    systemd.user.sockets.pipewire.enable = !cfg.systemWide;
    systemd.user.services.pipewire.enable = !cfg.systemWide;

    systemd.sockets.pipewire.wantedBy = lib.mkIf cfg.socketActivation [ "sockets.target" ];
    systemd.user.sockets.pipewire.wantedBy = lib.mkIf cfg.socketActivation [ "sockets.target" ];
    systemd.user.sockets.pipewire-pulse.wantedBy = lib.mkIf (cfg.socketActivation && cfg.pulse.enable) ["sockets.target"];

    services.udev.packages = [ cfg.package ];

    # If any paths are updated here they must also be updated in the package test.
    environment.etc."alsa/conf.d/49-pipewire-modules.conf" = mkIf cfg.alsa.enable {
      text = ''
        pcm_type.pipewire {
          libs.native = ${cfg.package.lib}/lib/alsa-lib/libasound_module_pcm_pipewire.so ;
          ${optionalString enable32BitAlsaPlugins
            "libs.32Bit = ${pkgs.pkgsi686Linux.pipewire.lib}/lib/alsa-lib/libasound_module_pcm_pipewire.so ;"}
        }
        ctl_type.pipewire {
          libs.native = ${cfg.package.lib}/lib/alsa-lib/libasound_module_ctl_pipewire.so ;
          ${optionalString enable32BitAlsaPlugins
            "libs.32Bit = ${pkgs.pkgsi686Linux.pipewire.lib}/lib/alsa-lib/libasound_module_ctl_pipewire.so ;"}
        }
      '';
    };
    environment.etc."alsa/conf.d/50-pipewire.conf" = mkIf cfg.alsa.enable {
      source = "${cfg.package}/share/alsa/alsa.conf.d/50-pipewire.conf";
    };
    environment.etc."alsa/conf.d/99-pipewire-default.conf" = mkIf cfg.alsa.enable {
      source = "${cfg.package}/share/alsa/alsa.conf.d/99-pipewire-default.conf";
    };

    environment.etc."pipewire/client.conf" = {
      source = json.generate "client.conf" configs.client;
    };
    environment.etc."pipewire/client-rt.conf" = {
      source = json.generate "client-rt.conf" configs.client-rt;
    };
    environment.etc."pipewire/jack.conf" = {
      source = json.generate "jack.conf" configs.jack;
    };
    environment.etc."pipewire/pipewire.conf" = {
      source = json.generate "pipewire.conf" configs.pipewire;
    };
    environment.etc."pipewire/pipewire-pulse.conf" = mkIf cfg.pulse.enable {
      source = json.generate "pipewire-pulse.conf" configs.pipewire-pulse;
    };

    environment.sessionVariables.LD_LIBRARY_PATH =
      lib.mkIf cfg.jack.enable [ "${cfg.package.jack}/lib" ];

    users = lib.mkIf cfg.systemWide {
      users.pipewire = {
        uid = config.ids.uids.pipewire;
        group = "pipewire";
        extraGroups = [
          "audio"
          "video"
        ] ++ lib.optional config.security.rtkit.enable "rtkit";
        description = "Pipewire system service user";
        isSystemUser = true;
        home = "/var/lib/pipewire";
        createHome = true;
      };
      groups.pipewire.gid = config.ids.gids.pipewire;
    };

    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/464#note_723554
    systemd.services.pipewire.environment."PIPEWIRE_LINK_PASSIVE" = "1";
    systemd.user.services.pipewire.environment."PIPEWIRE_LINK_PASSIVE" = "1";

    # pipewire-pulse default config expects pactl to be in PATH
    systemd.user.services.pipewire-pulse.path = lib.mkIf cfg.pulse.enable [ pkgs.pulseaudio ];
  };
}
