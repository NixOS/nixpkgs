# pipewire service.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pipewire;
  enable32BitAlsaPlugins = cfg.alsa.support32Bit
                           && pkgs.stdenv.isx86_64
                           && pkgs.pkgsi686Linux.pipewire != null;

  jack-libs = pkgs.runCommand "jack-libs" {} ''
    mkdir -p "$out/lib"
    ln -s "${pkgs.pipewire.lib}/lib/pipewire-0.3/jack" "$out/lib/pipewire"
  '';
  pulse-libs = pkgs.runCommand "pulse-libs" {} ''
    mkdir -p "$out/lib"
    ln -s "${pkgs.pipewire.lib}/lib/pipewire-0.3/pulse" "$out/lib/pipewire"
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
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Route audio to/from generic ALSA-using applications via the ALSA PIPEWIRE PCM plugin.
          '';
        };

        support32Bit = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Whether to support sound for 32-bit ALSA applications on a 64-bit system.
          '';
        };
      };

      jack = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Enable transparent JACK audio emulation using LD_LIBRARY_PATH.
          '';
        };
      };

      pulse = {
        enable = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Enable transparent PulseAudio emulation using LD_LIBRARY_PATH.
          '';
        };
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.pipewire ]
                                 ++ lib.optional cfg.jack.enable jack-libs
                                 ++ lib.optional cfg.pulse.enable pulse-libs;

    systemd.packages = [ pkgs.pipewire ];

    systemd.user.sockets.pipewire.wantedBy = lib.mkIf cfg.socketActivation [ "sockets.target" ];

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
    environment.sessionVariables.LD_LIBRARY_PATH = "/run/current-system/sw/lib/pipewire";
  };
}
