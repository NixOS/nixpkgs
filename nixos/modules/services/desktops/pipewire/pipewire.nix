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

  # Helpers for generating the pipewire JSON config file
  mkSPAValueString = v:
  if builtins.isList v then "[${lib.concatMapStringsSep " " mkSPAValueString v}]"
  else if lib.types.attrs.check v then
    "{${lib.concatStringsSep " " (mkSPAKeyValue v)}}"
  else lib.generators.mkValueStringDefault { } v;

  mkSPAKeyValue = attrs: map (def: def.content) (
  lib.sortProperties
    (
      lib.mapAttrsToList
        (k: v: lib.mkOrder (v._priority or 1000) "${lib.escape [ "=" ] k} = ${mkSPAValueString (v._content or v)}")
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

      config = mkOption {
        type = types.attrs;
        description = ''
          Configuration for the pipewire daemon.
        '';
        default = {
          properties = {
            ## set-prop is used to configure properties in the system
            #
            # "library.name.system" = "support/libspa-support";
            # "context.data-loop.library.name.system" = "support/libspa-support";
            "link.max-buffers" = 16; # version < 3 clients can't handle more than 16
            #"mem.allow-mlock" = false;
            #"mem.mlock-all" = true;
            ## https://gitlab.freedesktop.org/pipewire/pipewire/-/blob/master/src/pipewire/pipewire.h#L93
            #"log.level" = 2; # 5 is trace, which is verbose as hell, default is 2 which is warnings, 4 is debug output, 3 is info

            ## Properties for the DSP configuration
            #
            #"default.clock.rate" = 48000;
            #"default.clock.quantum" = 1024;
            #"default.clock.min-quantum" = 32;
            #"default.clock.max-quantum" = 8192;
            #"default.video.width" = 640;
            #"default.video.height" = 480;
            #"default.video.rate.num" = 25;
            #"default.video.rate.denom" = 1;
          };

          spa-libs = {
            ## add-spa-lib <factory-name regex> <library-name>
            #
            # used to find spa factory names. It maps an spa factory name
            # regular expression to a library name that should contain
            # that factory.
            #
            "audio.convert*" = "audioconvert/libspa-audioconvert";
            "api.alsa.*" = "alsa/libspa-alsa";
            "api.v4l2.*" = "v4l2/libspa-v4l2";
            "api.libcamera.*" = "libcamera/libspa-libcamera";
            "api.bluez5.*" = "bluez5/libspa-bluez5";
            "api.vulkan.*" = "vulkan/libspa-vulkan";
            "api.jack.*" = "jack/libspa-jack";
            "support.*" = "support/libspa-support";
            # "videotestsrc" = "videotestsrc/libspa-videotestsrc";
            # "audiotestsrc" = "audiotestsrc/libspa-audiotestsrc";
          };

          modules = {
            ##  <module-name> = { [args = "<key>=<value> ..."]
            #                     [flags = ifexists] }
            #                     [flags = [ifexists]|[nofail]}
            #
            # Loads a module with the given parameters.
            # If ifexists is given, the module is ignoed when it is not found.
            # If nofail is given, module initialization failures are ignored.
            #
            libpipewire-module-rtkit = {
              args = {
                #rt.prio = 20;
                #rt.time.soft = 200000;
                #rt.time.hard = 200000;
                #nice.level = -11;
              };
              flags = "ifexists|nofail";
            };
            libpipewire-module-protocol-native = { _priority = -100; _content = "null"; };
            libpipewire-module-profiler = "null";
            libpipewire-module-metadata = "null";
            libpipewire-module-spa-device-factory = "null";
            libpipewire-module-spa-node-factory = "null";
            libpipewire-module-client-node = "null";
            libpipewire-module-client-device = "null";
            libpipewire-module-portal = "null";
            libpipewire-module-access = {
              args.access = {
                allowed = ["${builtins.unsafeDiscardStringContext cfg.sessionManagerExecutable}"];
                rejected = [];
                restricted = [];
                force = "flatpak";
              };
            };
            libpipewire-module-adapter = "null";
            libpipewire-module-link-factory = "null";
            libpipewire-module-session-manager = "null";
          };

          objects = {
            ## create-object [-nofail] <factory-name> [<key>=<value> ...]
            #
            # Creates an object from a PipeWire factory with the given parameters.
            # If -nofail is given, errors are ignored (and no object is created)
            #
          };


          exec = {
            ## exec <program-name>
            #
            # Execute the given program. This is usually used to start the
            # session manager. run the session manager with -h for options
            #
            "${builtins.unsafeDiscardStringContext cfg.sessionManagerExecutable}" = { args = "\"${lib.concatStringsSep " " cfg.sessionManagerArguments}\""; };
          };
        };
      };

      sessionManagerExecutable = mkOption {
        type = types.str;
        default = "";
        example = literalExample ''${pkgs.pipewire.mediaSession}/bin/pipewire-media-session'';
        description = ''
          Path to the session manager executable.
        '';
      };

      sessionManagerArguments = mkOption {
        type = types.listOf types.str;
        default = [];
        example = literalExample ''["-p" "bluez5.msbc-support=true"]'';
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

    # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/464#note_723554
    systemd.user.services.pipewire.environment = {
      "PIPEWIRE_LINK_PASSIVE" = "1";
      "PIPEWIRE_CONFIG_FILE" = pkgs.writeText "pipewire.conf" (toSPAJSON cfg.config);
    };
  };
}
