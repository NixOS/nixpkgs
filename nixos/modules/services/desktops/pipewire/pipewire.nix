# PipeWire service.
{ config, lib, pkgs, ... }:

let
  inherit (builtins) attrNames concatMap length;
  inherit (lib) maintainers teams;
  inherit (lib.attrsets) attrByPath attrsToList concatMapAttrs filterAttrs;
  inherit (lib.lists) flatten optional optionals;
  inherit (lib.modules) mkIf mkRemovedOptionModule;
  inherit (lib.options) literalExpression mkEnableOption mkOption mkPackageOption;
  inherit (lib.strings) concatMapStringsSep hasPrefix optionalString;
  inherit (lib.types) attrsOf bool listOf package;

  json = pkgs.formats.json {};
  mapToFiles = location: config: concatMapAttrs (name: value: { "share/pipewire/${location}.conf.d/${name}.conf" = json.generate "${name}" value; }) config;
  extraConfigPkgFromFiles = locations: filesSet: pkgs.runCommand "pipewire-extra-config" { } ''
    mkdir -p ${concatMapStringsSep " " (l: "$out/share/pipewire/${l}.conf.d") locations}
    ${concatMapStringsSep ";" ({name, value}: "ln -s ${value} $out/${name}") (attrsToList filesSet)}
  '';
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

  configPackages = cfg.configPackages;

  extraConfigPkg = extraConfigPkgFromFiles
    [ "pipewire" "client" "client-rt" "jack" "pipewire-pulse" ]
    (
      mapToFiles "pipewire" cfg.extraConfig.pipewire
      // mapToFiles "client" cfg.extraConfig.client
      // mapToFiles "client-rt" cfg.extraConfig.client-rt
      // mapToFiles "jack" cfg.extraConfig.jack
      // mapToFiles "pipewire-pulse" cfg.extraConfig.pipewire-pulse
    );

  configs = pkgs.buildEnv {
    name = "pipewire-configs";
    paths = configPackages
      ++ [ extraConfigPkg ]
      ++ optionals cfg.wireplumber.enable cfg.wireplumber.configPackages;
    pathsToLink = [ "/share/pipewire" ];
  };

  requiredLv2Packages = flatten
    (
      concatMap
      (p:
        attrByPath ["passthru" "requiredLv2Packages"] [] p
      )
      configPackages
    );

  lv2Plugins = pkgs.buildEnv {
    name = "pipewire-lv2-plugins";
    paths = cfg.extraLv2Packages ++ requiredLv2Packages;
    pathsToLink = [ "/lib/lv2" ];
  };
in {
  meta.maintainers = teams.freedesktop.members ++ [ maintainers.k900 ];

  ###### interface
  options = {
    services.pipewire = {
      enable = mkEnableOption "PipeWire service";

      package = mkPackageOption pkgs "pipewire" { };

      socketActivation = mkOption {
        default = true;
        type = bool;
        description = ''
          Automatically run PipeWire when connections are made to the PipeWire socket.
        '';
      };

      audio = {
        enable = mkOption {
          type = bool;
          # this is for backwards compatibility
          default = cfg.alsa.enable || cfg.jack.enable || cfg.pulse.enable;
          defaultText = literalExpression "config.services.pipewire.alsa.enable || config.services.pipewire.jack.enable || config.services.pipewire.pulse.enable";
          description = "Whether to use PipeWire as the primary sound server";
        };
      };

      alsa = {
        enable = mkEnableOption "ALSA support";
        support32Bit = mkEnableOption "32-bit ALSA support on 64-bit systems";
      };

      jack = {
        enable = mkEnableOption "JACK audio emulation";
      };

      raopOpenFirewall = mkOption {
        type = bool;
        default = false;
        description = ''
          Opens UDP/6001-6002, required by RAOP/Airplay for timing and control data.
        '';
      };

      pulse = {
        enable = mkEnableOption "PulseAudio server emulation";
      };

      systemWide = mkOption {
        type = bool;
        default = false;
        description = ''
          If true, a system-wide PipeWire service and socket is enabled
          allowing all users in the "pipewire" group to use it simultaneously.
          If false, then user units are used instead, restricting access to
          only one user.

          Enabling system-wide PipeWire is however not recommended and disabled
          by default according to
          https://github.com/PipeWire/pipewire/blob/master/NEWS
        '';
      };

      extraConfig = {
        pipewire = mkOption {
          type = attrsOf json.type;
          default = {};
          example = {
            "10-clock-rate" = {
              "context.properties" = {
                "default.clock.rate" = 44100;
              };
            };
            "11-no-upmixing" = {
              "stream.properties" = {
                "channelmix.upmix" = false;
              };
            };
          };
          description = ''
            Additional configuration for the PipeWire server.

            Every item in this attrset becomes a separate drop-in file in `/etc/pipewire/pipewire.conf.d`.

            See `man pipewire.conf` for details, and [the PipeWire wiki][wiki] for examples.

            See also:
            - [PipeWire wiki - virtual devices][wiki-virtual-device] for creating virtual devices or remapping channels
            - [PipeWire wiki - filter-chain][wiki-filter-chain] for creating more complex processing pipelines
            - [PipeWire wiki - network][wiki-network] for streaming audio over a network

            [wiki]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PipeWire
            [wiki-virtual-device]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Virtual-Devices
            [wiki-filter-chain]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Filter-Chain
            [wiki-network]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Network
          '';
        };
        client = mkOption {
          type = attrsOf json.type;
          default = {};
          example = {
            "10-no-resample" = {
              "stream.properties" = {
                "resample.disable" = true;
              };
            };
          };
          description = ''
            Additional configuration for the PipeWire client library, used by most applications.

            Every item in this attrset becomes a separate drop-in file in `/etc/pipewire/client.conf.d`.

            See the [PipeWire wiki][wiki] for examples.

            [wiki]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-client
          '';
        };
        client-rt = mkOption {
          type = attrsOf json.type;
          default = {};
          example = {
            "10-alsa-linear-volume" = {
              "alsa.properties" = {
                "alsa.volume-method" = "linear";
              };
            };
          };
          description = ''
            Additional configuration for the PipeWire client library, used by real-time applications and legacy ALSA clients.

            Every item in this attrset becomes a separate drop-in file in `/etc/pipewire/client-rt.conf.d`.

            See the [PipeWire wiki][wiki] for examples of general configuration, and [PipeWire wiki - ALSA][wiki-alsa] for ALSA clients.

            [wiki]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-client
            [wiki-alsa]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-ALSA
          '';
        };
        jack = mkOption {
          type = attrsOf json.type;
          default = {};
          example = {
            "20-hide-midi" = {
              "jack.properties" = {
                "jack.show-midi" = false;
              };
            };
          };
          description = ''
            Additional configuration for the PipeWire JACK server and client library.

            Every item in this attrset becomes a separate drop-in file in `/etc/pipewire/jack.conf.d`.

            See the [PipeWire wiki][wiki] for examples.

            [wiki]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-JACK
          '';
        };
        pipewire-pulse = mkOption {
          type = attrsOf json.type;
          default = {};
          example = {
            "15-force-s16-info" = {
              "pulse.rules" = [{
                matches = [
                  { "application.process.binary" = "my-broken-app"; }
                ];
                actions = {
                  quirks = [ "force-s16-info" ];
                };
              }];
            };
          };
          description = ''
            Additional configuration for the PipeWire PulseAudio server.

            Every item in this attrset becomes a separate drop-in file in `/etc/pipewire/pipewire-pulse.conf.d`.

            See `man pipewire-pulse.conf` for details, and [the PipeWire wiki][wiki] for examples.

            See also:
            - [PipeWire wiki - PulseAudio tricks guide][wiki-tricks] for more examples.

            [wiki]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Config-PulseAudio
            [wiki-tricks]: https://gitlab.freedesktop.org/pipewire/pipewire/-/wikis/Guide-PulseAudio-Tricks
          '';
        };
      };

      configPackages = mkOption {
        type = listOf package;
        default = [];
        example = literalExpression ''[
          (pkgs.writeTextDir "share/pipewire/pipewire.conf.d/10-loopback.conf" '''
            context.modules = [
            {   name = libpipewire-module-loopback
                args = {
                  node.description = "Scarlett Focusrite Line 1"
                  capture.props = {
                      audio.position = [ FL ]
                      stream.dont-remix = true
                      node.target = "alsa_input.usb-Focusrite_Scarlett_Solo_USB_Y7ZD17C24495BC-00.analog-stereo"
                      node.passive = true
                  }
                  playback.props = {
                      node.name = "SF_mono_in_1"
                      media.class = "Audio/Source"
                      audio.position = [ MONO ]
                  }
                }
            }
            ]
          ''')
        ]'';
        description = ''
          List of packages that provide PipeWire configuration, in the form of
          `share/pipewire/*/*.conf` files.

          LV2 dependencies will be picked up from config packages automatically
          via `passthru.requiredLv2Packages`.
        '';
      };

      extraLv2Packages = mkOption {
        type = listOf package;
        default = [];
        example = literalExpression "[ pkgs.lsp-plugins ]";
        description = ''
          List of packages that provide LV2 plugins in `lib/lv2` that should
          be made available to PipeWire for [filter chains][wiki-filter-chain].

          Config packages have their required LV2 plugins added automatically,
          so they don't need to be specified here. Config packages need to set
          `passthru.requiredLv2Packages` for this to work.

          [wiki-filter-chain]: https://docs.pipewire.org/page_module_filter_chain.html
        '';
      };
    };
  };

  imports = [
    (mkRemovedOptionModule ["services" "pipewire" "config"] ''
      Overriding default PipeWire configuration through NixOS options never worked correctly and is no longer supported.
      Please create drop-in configuration files via `services.pipewire.extraConfig` instead.
    '')
    (mkRemovedOptionModule ["services" "pipewire" "media-session"] ''
      pipewire-media-session is no longer supported upstream and has been removed.
      Please switch to `services.pipewire.wireplumber` instead.
    '')
  ];

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
      {
        assertion = length
          (attrNames
            (
              filterAttrs
                (name: value:
                  hasPrefix "pipewire/" name || name == "pipewire"
                )
                config.environment.etc
            )) == 1;
        message = "Using `environment.etc.\"pipewire<...>\"` directly is no longer supported in 24.05. Use `services.pipewire.extraConfig` or `services.pipewire.configPackages` instead.";
      }
    ];

    environment.systemPackages = [ cfg.package ]
                                 ++ optional cfg.jack.enable jack-libs;

    systemd.packages = [ cfg.package ];

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

    systemd.services.pipewire.environment.LV2_PATH = mkIf cfg.systemWide "${lv2Plugins}/lib/lv2";
    systemd.user.services.pipewire.environment.LV2_PATH = mkIf (!cfg.systemWide) "${lv2Plugins}/lib/lv2";

    # Mask pw-pulse if it's not wanted
    systemd.user.services.pipewire-pulse.enable = cfg.pulse.enable;
    systemd.user.sockets.pipewire-pulse.enable = cfg.pulse.enable;

    systemd.sockets.pipewire.wantedBy = mkIf cfg.socketActivation [ "sockets.target" ];
    systemd.user.sockets.pipewire.wantedBy = mkIf cfg.socketActivation [ "sockets.target" ];
    systemd.user.sockets.pipewire-pulse.wantedBy = mkIf cfg.socketActivation [ "sockets.target" ];

    services.udev.packages = [ cfg.package ];

    # If any paths are updated here they must also be updated in the package test.
    environment.etc = {
      "alsa/conf.d/49-pipewire-modules.conf" = mkIf cfg.alsa.enable {
        text = ''
          pcm_type.pipewire {
            libs.native = ${cfg.package}/lib/alsa-lib/libasound_module_pcm_pipewire.so ;
            ${optionalString enable32BitAlsaPlugins
              "libs.32Bit = ${pkgs.pkgsi686Linux.pipewire}/lib/alsa-lib/libasound_module_pcm_pipewire.so ;"}
          }
          ctl_type.pipewire {
            libs.native = ${cfg.package}/lib/alsa-lib/libasound_module_ctl_pipewire.so ;
            ${optionalString enable32BitAlsaPlugins
              "libs.32Bit = ${pkgs.pkgsi686Linux.pipewire}/lib/alsa-lib/libasound_module_ctl_pipewire.so ;"}
          }
        '';
      };

      "alsa/conf.d/50-pipewire.conf" = mkIf cfg.alsa.enable {
        source = "${cfg.package}/share/alsa/alsa.conf.d/50-pipewire.conf";
      };

      "alsa/conf.d/99-pipewire-default.conf" = mkIf cfg.alsa.enable {
        source = "${cfg.package}/share/alsa/alsa.conf.d/99-pipewire-default.conf";
      };
      pipewire.source = "${configs}/share/pipewire";
    };

    environment.sessionVariables.LD_LIBRARY_PATH =
      mkIf cfg.jack.enable [ "${cfg.package.jack}/lib" ];

    networking.firewall.allowedUDPPorts = mkIf cfg.raopOpenFirewall [ 6001 6002 ];

    # See https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/master/src/modules/module-rt/25-pw-rlimits.conf.in
    security.pam.loginLimits = [
      {
        domain = "@pipewire";
        item = "rtprio";
        type = "-";
        value = 95;
      }
      {
        domain = "@pipewire";
        item = "nice";
        type = "-";
        value = -19;
      }
      {
        domain = "@pipewire";
        item = "memlock";
        type = "-";
        value = 4194304;
      }
    ];

    users = {
      users.pipewire = mkIf cfg.systemWide {
        uid = config.ids.uids.pipewire;
        group = "pipewire";
        extraGroups = [
          "audio"
          "video"
        ] ++ optional config.security.rtkit.enable "rtkit";
        description = "PipeWire system service user";
        isSystemUser = true;
        home = "/var/lib/pipewire";
        createHome = true;
      };
      groups.pipewire.gid = config.ids.gids.pipewire;
    };
  };
}
