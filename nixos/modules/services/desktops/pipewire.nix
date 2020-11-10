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
    ln -s "${pkgs.pipewire.jack}/lib" "$out/lib/pipewire"
  '';
  pulse-libs = pkgs.runCommand "pulse-libs" {} ''
    mkdir -p "$out/lib"
    ln -s "${pkgs.pipewire.pulse}/lib" "$out/lib/pipewire"
  '';
in {

  meta = {
    maintainers = teams.freedesktop.members;
  };

  ###### interface
  options = {
    services.pipewire = {
      enable = mkEnableOption "pipewire service";

      socketActivation = mkOption {
        default = true;
        type = types.bool;
        description = ''
          Automatically run pipewire when connections are made to the pipewire socket.
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
        enable = mkEnableOption "PulseAudio emulation";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.pulse.enable -> !config.hardware.pulseaudio.enable;
        message = "PipeWire based PulseAudio emulation doesn't use the PulseAudio service";
      }
      {
        assertion = cfg.jack.enable -> !config.services.jack.jackd.enable;
        message = "PIpeWire based JACK emulation doesn't use the JACK service";
      }
    ];

    environment.systemPackages = [ pkgs.pipewire ]
                                 ++ lib.optional cfg.jack.enable jack-libs
                                 ++ lib.optional cfg.pulse.enable pulse-libs;

    systemd.packages = [ pkgs.pipewire ];

    # PipeWire depends on DBUS but doesn't list it. Without this booting
    # into a terminal results in the service crashing with an error.
    systemd.user.sockets.pipewire.wantedBy = lib.mkIf cfg.socketActivation [ "sockets.target" ];
    systemd.user.services.pipewire.bindsTo = [ "dbus.service" ];
    services.udev.packages = [ pkgs.pipewire ];

    # If any paths are updated here they must also be updated in the package test.
    sound.extraConfig = mkIf cfg.alsa.enable ''
      pcm_type.pipewire {
        libs.native = ${pkgs.pipewire.lib}/lib/alsa-lib/libasound_module_pcm_pipewire.so ;
        ${optionalString enable32BitAlsaPlugins
          "libs.32Bit = ${pkgs.pkgsi686Linux.pipewire.lib}/lib/alsa-lib/libasound_module_pcm_pipewire.so ;"}
      }
      pcm.!default {
        @func getenv
        vars [ PCM ]
        default "plug:pipewire"
        playback_mode "-1"
        capture_mode "-1"
      }
    '';
    environment.etc."alsa/conf.d/50-pipewire.conf" = mkIf cfg.alsa.enable {
      source = "${pkgs.pipewire}/share/alsa/alsa.conf.d/50-pipewire.conf";
    };
    environment.sessionVariables.LD_LIBRARY_PATH =
      lib.optional (cfg.jack.enable || cfg.pulse.enable) "/run/current-system/sw/lib/pipewire";
  };
}
