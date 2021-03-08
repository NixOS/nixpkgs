# pipewire service.
{ config, lib, pkgs, ... }:

with lib;

let
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
in {

  meta = {
    maintainers = teams.freedesktop.members;
  };

  ###### interface
  options = {
    services.pipewire = {
      enable = mkEnableOption "pipewire service";

      package = mkOption {
        type = types.package;
        default = pkgs.pipewire;
        defaultText = "pkgs.pipewire";
        example = literalExample "pkgs.pipewire";
        description = ''
          The pipewire derivation to use.
        '';
      };

      socketActivation = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Automatically run pipewire when connections are made to the pipewire socket.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Literal string to append to /etc/pipewire/pipewire.conf.
        '';
      };

      sessionManager = mkOption {
        type = types.nullOr types.string;
        default = null;
        example = literalExample ''"''${pipewire}/bin/pipewire-media-session"'';
        description = ''
          Path to the pipewire session manager executable.
        '';
      };

      sessionManagerArguments = mkOption {
        type = types.listOf types.string;
        default = [];
        example = literalExample ''[ "-p" "bluez5.msbc-support=true" ]'';
        description = ''
          Arguments passed to the pipewire session manager.
        '';
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
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.pulse.enable -> !config.hardware.pulseaudio.enable;
        message = "PipeWire based PulseAudio server emulation replaces PulseAudio. This option requires `hardware.pulseaudio.enable` to be set to false";
      }
      {
        assertion = cfg.jack.enable -> !config.services.jack.jackd.enable;
        message = "PipeWire based JACK emulation doesn't use the JACK service. This option requires `services.jack.jackd.enable` to be set to false";
      }
    ];

    services.pipewire.sessionManager = mkDefault "${cfg.package}/bin/pipewire-media-session";

    environment.systemPackages = [ cfg.package ]
                                 ++ lib.optional cfg.jack.enable jack-libs;

    systemd.packages = [ cfg.package ]
                       ++ lib.optional cfg.pulse.enable cfg.package.pulse;

    # PipeWire depends on DBUS but doesn't list it. Without this booting
    # into a terminal results in the service crashing with an error.
    systemd.user.sockets.pipewire.wantedBy = lib.mkIf cfg.socketActivation [ "sockets.target" ];
    systemd.user.sockets.pipewire-pulse.wantedBy = lib.mkIf (cfg.socketActivation && cfg.pulse.enable) ["sockets.target"];
    systemd.user.services.pipewire.bindsTo = [ "dbus.service" ];
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
    environment.sessionVariables.LD_LIBRARY_PATH =
      lib.optional cfg.jack.enable "/run/current-system/sw/lib/pipewire";

    environment.etc."pipewire/pipewire.conf" = {
      # Adapted from src/daemon/pipewire.conf.in
      text = ''
        set-prop link.max-buffers 16 # version < 3 clients can't handle more

        add-spa-lib audio.convert* audioconvert/libspa-audioconvert
        add-spa-lib api.alsa.* alsa/libspa-alsa
        add-spa-lib api.v4l2.* v4l2/libspa-v4l2
        add-spa-lib api.libcamera.* libcamera/libspa-libcamera
        add-spa-lib api.bluez5.* bluez5/libspa-bluez5
        add-spa-lib api.vulkan.* vulkan/libspa-vulkan
        add-spa-lib api.jack.* jack/libspa-jack
        add-spa-lib support.* support/libspa-support

        load-module libpipewire-module-rtkit # rt.prio=20 rt.time.soft=200000 rt.time.hard=200000
        load-module libpipewire-module-protocol-native
        load-module libpipewire-module-profiler
        load-module libpipewire-module-metadata
        load-module libpipewire-module-spa-device-factory
        load-module libpipewire-module-spa-node-factory
        load-module libpipewire-module-client-node
        load-module libpipewire-module-client-device
        load-module libpipewire-module-portal
        load-module libpipewire-module-access
        load-module libpipewire-module-adapter
        load-module libpipewire-module-link-factory
        load-module libpipewire-module-session-manager

        create-object spa-node-factory factory.name=support.node.driver node.name=Dummy priority.driver=8000

        exec ${cfg.sessionManager} ${lib.concatStringsSep " " cfg.sessionManagerArguments}

        ${cfg.extraConfig}
      '';
    };

    environment.etc."pipewire/media-session.d/with-alsa" = mkIf cfg.alsa.enable { text = ""; };
    environment.etc."pipewire/media-session.d/with-pulseaudio" = mkIf cfg.pulse.enable { text = ""; };
    environment.etc."pipewire/media-session.d/with-jack" = mkIf cfg.jack.enable { text = ""; };
  };
}
