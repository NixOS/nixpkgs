# pipewire example session manager.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pipewire.media-session;
  enable32BitAlsaPlugins = cfg.alsa.support32Bit
                           && pkgs.stdenv.isx86_64
                           && pkgs.pkgsi686Linux.pipewire != null;

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

      config = mkOption {
        type = types.attrs;
        description = ''
          Configuration for the media session core.
        '';
        default = {
          # media-session config file
          properties = {
            # Properties to configure the session and some
            # modules
            #mem.mlock-all = false;
            #context.profile.modules = "default,rtkit";
          };

          spa-libs = {
            # Mapping from factory name to library.
            "api.bluez5.*" = "bluez5/libspa-bluez5";
            "api.alsa.*" = "alsa/libspa-alsa";
            "api.v4l2.*" = "v4l2/libspa-v4l2";
            "api.libcamera.*" = "libcamera/libspa-libcamera";
          };

          modules = {
            # These are the modules that are enabled when a file with
            # the key name is found in the media-session.d config directory.
            # the default bundle is always enabled.

            default = [
              "flatpak"			# manages flatpak access
              "portal"			# manage portal permissions
              "v4l2"			# video for linux udev detection
              #"libcamera"		# libcamera udev detection
              "suspend-node"		# suspend inactive nodes
              "policy-node"		# configure and link nodes
              #"metadata"		# export metadata API
              #"default-nodes"		# restore default nodes
              #"default-profile"	# restore default profiles
              #"default-routes"		# restore default route
              #"streams-follow-default"	# move streams when default changes
              #"alsa-seq"		# alsa seq midi support
              #"alsa-monitor"		# alsa udev detection
              #"bluez5"			# bluetooth support
              #"restore-stream"		# restore stream settings
            ];
            "with-audio" = [
              "metadata"
              "default-nodes"
              "default-profile"
              "default-routes"
              "alsa-seq"
              "alsa-monitor"
            ];
            "with-alsa" = [
              "with-audio"
            ];
            "with-jack" = [
              "with-audio"
            ];
            "with-pulseaudio" = [
              "with-audio"
              "bluez5"
              "restore-stream"
              "streams-follow-default"
            ];
          };
        };
      };

      alsaMonitorConfig = mkOption {
        type = types.attrs;
        description = ''
          Configuration for the alsa monitor.
        '';
        default = {
          # alsa-monitor config file
          properties = {
            #alsa.jack-device = true
          };

          rules = [
          # an array of matches/actions to evaluate
          {
            # rules for matching a device or node. It is an array of
            # properties that all need to match the regexp. If any of the
            # matches work, the actions are executed for the object.
            matches = [
              {
                # this matches all cards
                device.name = "~alsa_card.*";
              }
            ];
            actions = {
              # actions can update properties on the matched object.
              update-props = {
                api.alsa.use-acp = true;
                #api.alsa.use-ucm = true;
                #api.alsa.soft-mixer = false;
                #api.alsa.ignore-dB = false;
                #device.profile-set = "profileset-name";
                #device.profile = "default profile name";
                api.acp.auto-profile = false;
                api.acp.auto-port = false;
                #device.nick = "My Device";
              };
            };
          }
          {
            matches = [
              {
                # matches all sinks
                node.name = "~alsa_input.*";
              }
              {
                # matches all sources
                node.name = "~alsa_output.*";
              }
            ];
            actions = {
              update-props = {
                #node.nick = 			"My Node";
                #node.nick = 			null;
                #priority.driver = 		100;
                #priority.session = 		100;
                #node.pause-on-idle = 		false;
                #resample.quality = 		4;
                #channelmix.normalize =		false;
                #channelmix.mix-lfe = 		false;
                #audio.channels = 		2;
                #audio.format = 		"S16LE";
                #audio.rate = 			44100;
                #audio.position = 		"FL,FR";
                #api.alsa.period-size =         1024;
                #api.alsa.headroom =            0;
                #api.alsa.disable-mmap =        false;
                #api.alsa.disable-batch =       false;
              };
            };
          }
          ];
        };
      };

      bluezMonitorConfig = mkOption {
        type = types.attrs;
        description = ''
          Configuration for the bluez5 monitor.
        '';
        default = {
          # bluez-monitor config file
          properties = {
            # msbc is not expected to work on all headset + adapter combinations.
            #bluez5.msbc-support = true;
            #bluez5.sbc-xq-support = true;

            # Enabled headset roles (default: [ hsp_hs hfp_ag ]), this
            # property only applies to native backend. Currently some headsets
            # (Sony WH-1000XM3) are not working with both hsp_ag and hfp_ag
            # enabled, disable either hsp_ag or hfp_ag to work around it.
            #
            # Supported headset roles: hsp_hs (HSP Headset),
            #                          hsp_ag (HSP Audio Gateway),
            #                          hfp_ag (HFP Audio Gateway)
            #bluez5.headset-roles = [ "hsp_hs" "hsp_ag" "hfp_ag" ];

            # Enabled A2DP codecs (default: all)
            #bluez5.codecs = [ "sbc" "aac" "ldac" "aptx" "aptx_hd" ];
          };

          rules = [
          # an array of matches/actions to evaluate
          {
            # rules for matching a device or node. It is an array of
            # properties that all need to match the regexp. If any of the
            # matches work, the actions are executed for the object.
            matches = [
              {
                # this matches all cards
                device.name = "~bluez_card.*";
              }
            ];
            actions = {
              # actions can update properties on the matched object.
              update-props = {
                #device.nick = 			"My Device";
              };
            };
          }
          {
            matches = [
              {
                # matches all sinks
                node.name = "~bluez_input.*";
              }
              {
                # matches all sources
                node.name = "~bluez_output.*";
              }
            ];
            actions = {
              update-props = {
                #node.nick = 			"My Node"
                #node.nick = 			null;
                #priority.driver = 		100;
                #priority.session = 		100;
                #node.pause-on-idle = 		false;
                #resample.quality = 		4;
                #channelmix.normalize =		false;
                #channelmix.mix-lfe = 		false;
              };
            };
          }
          ];
        };
      };

      v4l2MonitorConfig = mkOption {
        type = types.attrs;
        description = ''
          Configuration for the V4L2 monitor.
        '';
        default = {
          # v4l2-monitor config file
          properties = {
          };

          rules = [
            # an array of matches/actions to evaluate
            {
              # rules for matching a device or node. It is an array of
              # properties that all need to match the regexp. If any of the
              # matches work, the actions are executed for the object.
              matches = [
                {
                  # this matches all devices
                  device.name = "~v4l2_device.*";
                }
              ];
              actions = {
                # actions can update properties on the matched object.
                update-props = {
                  #device.nick = 			"My Device";
                };
              };
            }
            {
              matches = [
                {
                  # matches all sinks
                  node.name = "~v4l2_input.*";
                }
                {
                  # matches all sources
                  node.name = "~v4l2_output.*";
                }
              ];
              actions = {
                update-props = {
                  #node.nick = 			"My Node";
                  #node.nick = 			null;
                  #priority.driver = 		100;
                  #priority.session = 		100;
                  #node.pause-on-idle = 		true;
                };
              };
            }
          ];
        };
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.pipewire.sessionManagerExecutable = "${cfg.package}/bin/pipewire-media-session";

    environment.etc."pipewire/media-session.d/media-session.conf" = { text = toSPAJSON cfg.config; };
    environment.etc."pipewire/media-session.d/v4l2-monitor.conf" = { text = toSPAJSON cfg.v4l2MonitorConfig; };

    environment.etc."pipewire/media-session.d/with-alsa" = mkIf config.services.pipewire.alsa.enable { text = ""; };
    environment.etc."pipewire/media-session.d/alsa-monitor.conf" = mkIf config.services.pipewire.alsa.enable { text = toSPAJSON cfg.alsaMonitorConfig; };

    environment.etc."pipewire/media-session.d/with-pulseaudio" = mkIf config.services.pipewire.pulse.enable { text = ""; };
    environment.etc."pipewire/media-session.d/bluez-monitor.conf" = mkIf config.services.pipewire.pulse.enable { text = toSPAJSON cfg.bluezMonitorConfig; };

    environment.etc."pipewire/media-session.d/with-jack" = mkIf config.services.pipewire.jack.enable { text = ""; };
  };
}
