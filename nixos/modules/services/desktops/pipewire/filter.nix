# pipewire filters
{ config, lib, pkgs, ... }:

with lib;

let
  pwcfg = config.services.pipewire;

  makeFilterChainConf = args: generators.toJSON {} {
    "context.properties" = {
      "log.level" = 0;
    };
    "context.spa-libs" = {
      "audio.convert.*" = "audioconvert/libspa-audioconvert";
      "support.*" = "support/libspa-support";
    };

    "context.modules" = [
      {
        name = "libpipewire-module-rtkit";
        args = {
          #"nice.level"   = -11;
          #"rt.prio"      = 88;
          #"rt.time.soft" = 2000000;
          #"rt.time.hard" = 2000000;
        };
        flags = [ "ifexists" "nofail" ];
      }
      { name = "libpipewire-module-protocol-native"; }
      { name = "libpipewire-module-client-node"; }
      { name = "libpipewire-module-adapter"; }

      {
        name = "libpipewire-module-filter-chain";
        inherit args;
      }
    ];
  };

  makeConfig = { name, description, conf }: let
    unit = {
      inherit description;

      wantedBy = [ "pipewire.service" ];
      bindsTo = [ "pipewire.service" ];
      after = [ "pipewire.service" ];

      script = "exec ${pwcfg.package}/bin/pipewire -c ${pkgs.writeText "filter-chain.conf" conf}";
    };
  in {
    systemd.services.${name} = unit // { enable = pwcfg.systemWide; };
    systemd.user.services.${name} = unit // { enable = !pwcfg.systemWide; };
  };

in
{
  options.services.pipewire = {
    deepfilter = {
      enable = mkEnableOption "deepfilter plugin for pipewire";

      attenuationLimit = mkOption {
        type = types.numbers.between 0 100;
        default = 100;
        # from <https://github.com/Rikorose/DeepFilterNet/blob/f96e8366f222776bcb31d0725bdbacc814220412/ladspa/filter-chain-configs/deepfilter-mono-source.conf#L17-L19>
        description = ''
          Decibels. You may limit the noise attenuation (i.e. don't reduce all
          noise) by setting this option to a smaller value. For little noise
          reduction, try 6-12, for medium noise reduction 18-24 dB. 100 dB
          means no attenuation limit.
        '';
      };
    };
    rnnoise = {
      enable = mkEnableOption "rnnoise plugin for pipewire";

      vadThreshold = mkOption {
        type = types.numbers.between 0 100;
        default = 50;
        description = ''
          Percentage. If probability of sound being a voice is lower than this
          threshold - it will be silenced. In most cases the threshold between
          85% - 95% would be fine. Without the VAD some loud noises may still
          be a bit audible when there is no voice.
        '';
      };
      vadGradePeriod = mkOption {
        type = types.numbers.nonnegative;
        default = 200;
        description = ''
          Milliseconds. For how long after the last voice detection the output
          won't be silenced. This helps when ends of words/sentences are being
          cut off.
        '';
      };
      retroactiveVadGradePeriod = mkOption {
        type = types.numbers.nonnegative;
        default = 0;
        description = ''
          Milliseconds. Similar to vadGradePeriod but for starts of
          words/sentences. This introduces latency!
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf pwcfg.deepfilter.enable (makeConfig {
      name = "pipewire-deepfilter";
      description = "DeepFilter plugin for pipewire";
      # based on https://github.com/Rikorose/DeepFilterNet/blob/main/ladspa/filter-chain-configs/deepfilter-mono-source.conf
      conf = makeFilterChainConf {
        "node.description" = "DeepFilter Noise Canceling Source";
        "media.name" = "DeepFilter Noise Canceling Source";
        "filter.graph".nodes = [ {
          type = "ladspa";
          name = "DeepFilter Mono";
          plugin = "${pkgs.deepfilter-ladspa}/lib/ladspa/libdeep_filter_ladspa.so";
          label = "deep_filter_mono";
          control = {
            "Attenuation Limit (dB)" = pwcfg.deepfilter.attenuationLimit;
          };
        } ];
        "audio.rate" = 48000;
        "audio.position" = ["FL"];
        "capture.props" = {
          "node.passive" = true;
        };
        "playback.props" = {
          "media.class" = "Audio/Source";
        };
      };
    }))

    (mkIf pwcfg.rnnoise.enable (makeConfig {
      name = "pipewire-rnnoise";
      description = "RNNoise plugin for pipewire";
      # based on https://github.com/werman/noise-suppression-for-voice#pipewire
      conf = makeFilterChainConf {
        "node.description" = "Noise Cancelling source";
        "media.name" = "Noise Cancelling source";
        "filter.graph".nodes = [ {
          type = "ladspa";
          name = "rnnoise";
          plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
          label = "noise_suppressor_mono";
          control = {
            "VAD Threshold (%)" = pwcfg.rnnoise.vadThreshold;
            "VAD Grace Period (ms)" = pwcfg.rnnoise.vadGradePeriod;
            "Retroactive VAD Grace (ms)" = pwcfg.rnnoise.retroactiveVadGradePeriod;
          };
        } ];
        "capture.props" = {
          "node.name" = "capture.rnnoise_source";
          "node.passive" = true;
          "audio.rate" = 48000;
        };
        "playback.props" = {
          "node.name" = "rnnoise_soure";
          "media.class" = "Audio/Source";
          "audio.rate" = 48000;
        };
      };
    }))
  ];
}
