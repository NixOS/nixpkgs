{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.jack;

  pcmPlugin = cfg.jackd.enable && cfg.alsa.enable;
  loopback = cfg.jackd.enable && cfg.loopback.enable;

  enable32BitAlsaPlugins = cfg.alsa.support32Bit && pkgs.stdenv.hostPlatform.isx86_64 && pkgs.pkgsi686Linux.alsa-lib != null;

  umaskNeeded = versionOlder cfg.jackd.package.version "1.9.12";
  bridgeNeeded = versionAtLeast cfg.jackd.package.version "1.9.12";
in {
  options = {
    services.jack = {
      jackd = {
        enable = mkEnableOption ''
          JACK Audio Connection Kit. You need to add yourself to the "jackaudio" group
        '';

        package = mkPackageOption pkgs "jack2" {
          example = "jack1";
        } // {
          # until jack1 promiscuous mode is fixed
          internal = true;
        };

        extraOptions = mkOption {
          type = types.listOf types.str;
          default = [
            "-dalsa"
          ];
          example = literalExpression ''
            [ "-dalsa" "--device" "hw:1" ];
          '';
          description = ''
            Specifies startup command line arguments to pass to JACK server.
          '';
        };

        session = mkOption {
          type = types.lines;
          description = ''
            Commands to run after JACK is started.
          '';
        };

      };

      alsa = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Route audio to/from generic ALSA-using applications using ALSA JACK PCM plugin.
          '';
        };

        support32Bit = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Whether to support sound for 32-bit ALSA applications on 64-bit system.
          '';
        };
      };

      loopback = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Create ALSA loopback device, instead of using PCM plugin. Has broader
            application support (things like Steam will work), but may need fine-tuning
            for concrete hardware.
          '';
        };

        index = mkOption {
          type = types.int;
          default = 10;
          description = ''
            Index of an ALSA loopback device.
          '';
        };

        config = mkOption {
          type = types.lines;
          description = ''
            ALSA config for loopback device.
          '';
        };

        dmixConfig = mkOption {
          type = types.lines;
          default = "";
          example = ''
            period_size 2048
            periods 2
          '';
          description = ''
            For music production software that still doesn't support JACK natively you
            would like to put buffer/period adjustments here
            to decrease dmix device latency.
          '';
        };

        session = mkOption {
          type = types.lines;
          description = ''
            Additional commands to run to setup loopback device.
          '';
        };
      };

    };

  };

  config = mkMerge [

    (mkIf pcmPlugin {
      environment.etc."alsa/conf.d/98-jack.conf".text = ''
        pcm_type.jack {
          libs.native = ${pkgs.alsa-plugins}/lib/alsa-lib/libasound_module_pcm_jack.so ;
          ${lib.optionalString enable32BitAlsaPlugins
          "libs.32Bit = ${pkgs.pkgsi686Linux.alsa-plugins}/lib/alsa-lib/libasound_module_pcm_jack.so ;"}
        }
        pcm.!default {
          @func getenv
          vars [ PCM ]
          default "plug:jack"
        }
      '';
    })

    (mkIf loopback {
      boot.kernelModules = [ "snd-aloop" ];
      boot.kernelParams = [ "snd-aloop.index=${toString cfg.loopback.index}" ];
      environment.etc."alsa/conf.d/99-jack-loopback.conf".text = cfg.loopback.config;
    })

    (mkIf cfg.jackd.enable {
      services.jack.jackd.session = ''
        ${lib.optionalString bridgeNeeded "${pkgs.a2jmidid}/bin/a2jmidid -e &"}
      '';
      # https://alsa.opensrc.org/Jack_and_Loopback_device_as_Alsa-to-Jack_bridge#id06
      services.jack.loopback.config = ''
        pcm.loophw00 {
          type hw
          card ${toString cfg.loopback.index}
          device 0
          subdevice 0
        }
        pcm.amix {
          type dmix
          ipc_key 219345
          slave {
            pcm loophw00
            ${cfg.loopback.dmixConfig}
          }
        }
        pcm.asoftvol {
          type softvol
          slave.pcm "amix"
          control { name Master }
        }
        pcm.cloop {
          type hw
          card ${toString cfg.loopback.index}
          device 1
          subdevice 0
          format S32_LE
        }
        pcm.loophw01 {
          type hw
          card ${toString cfg.loopback.index}
          device 0
          subdevice 1
        }
        pcm.ploop {
          type hw
          card ${toString cfg.loopback.index}
          device 1
          subdevice 1
          format S32_LE
        }
        pcm.aduplex {
          type asym
          playback.pcm "asoftvol"
          capture.pcm "loophw01"
        }
        pcm.!default {
          type plug
          slave.pcm aduplex
        }
      '';
      services.jack.loopback.session = ''
        alsa_in -j cloop -dcloop &
        alsa_out -j ploop -dploop &
        while [ "$(jack_lsp cloop)" == "" ] || [ "$(jack_lsp ploop)" == "" ]; do sleep 1; done
        jack_connect cloop:capture_1 system:playback_1
        jack_connect cloop:capture_2 system:playback_2
        jack_connect system:capture_1 ploop:playback_1
        jack_connect system:capture_2 ploop:playback_2
      '';

      assertions = [
        {
          assertion = !(cfg.alsa.enable && cfg.loopback.enable);
          message = "For JACK both alsa and loopback options shouldn't be used at the same time.";
        }
      ];

      users.users.jackaudio = {
        group = "jackaudio";
        extraGroups = [ "audio" ];
        description = "JACK Audio system service user";
        isSystemUser = true;
      };
      # https://jackaudio.org/faq/linux_rt_config.html
      security.pam.loginLimits = [
        { domain = "@jackaudio"; type = "-"; item = "rtprio"; value = "99"; }
        { domain = "@jackaudio"; type = "-"; item = "memlock"; value = "unlimited"; }
      ];
      users.groups.jackaudio = {};

      environment = {
        systemPackages = [ cfg.jackd.package ];
        etc."alsa/conf.d/50-jack.conf".source = "${pkgs.alsa-plugins}/etc/alsa/conf.d/50-jack.conf";
        variables.JACK_PROMISCUOUS_SERVER = "jackaudio";
      };

      services.udev.extraRules = ''
        ACTION=="add", SUBSYSTEM=="sound", ATTRS{id}!="Loopback", TAG+="systemd", ENV{SYSTEMD_WANTS}="jack.service"
      '';

      systemd.services.jack = {
        description = "JACK Audio Connection Kit";
        serviceConfig = {
          User = "jackaudio";
          SupplementaryGroups = lib.optional
            (config.hardware.pulseaudio.enable
            && !config.hardware.pulseaudio.systemWide) "users";
          ExecStart = "${cfg.jackd.package}/bin/jackd ${lib.escapeShellArgs cfg.jackd.extraOptions}";
          LimitRTPRIO = 99;
          LimitMEMLOCK = "infinity";
        } // optionalAttrs umaskNeeded {
          UMask = "007";
        };
        path = [ cfg.jackd.package ];
        environment = {
          JACK_PROMISCUOUS_SERVER = "jackaudio";
          JACK_NO_AUDIO_RESERVATION = "1";
        };
        restartIfChanged = false;
      };
      systemd.services.jack-session = {
        description = "JACK session";
        script = ''
          jack_wait -w
          ${cfg.jackd.session}
          ${lib.optionalString cfg.loopback.enable cfg.loopback.session}
        '';
        serviceConfig = {
          RemainAfterExit = true;
          User = "jackaudio";
          StateDirectory = "jack";
          LimitRTPRIO = 99;
          LimitMEMLOCK = "infinity";
        };
        path = [ cfg.jackd.package ];
        environment = {
          JACK_PROMISCUOUS_SERVER = "jackaudio";
          HOME = "/var/lib/jack";
        };
        wantedBy = [ "jack.service" ];
        partOf = [ "jack.service" ];
        after = [ "jack.service" ];
        restartIfChanged = false;
      };
    })

  ];

  meta.maintainers = [ ];
}
