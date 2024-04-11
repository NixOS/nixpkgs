{ config, lib, pkgs, ... }:

let
  inherit (builtins) attrNames concatMap length;
  inherit (lib) maintainers;
  inherit (lib.attrsets) attrByPath filterAttrs;
  inherit (lib.lists) flatten optional;
  inherit (lib.modules) mkIf;
  inherit (lib.options) literalExpression mkOption;
  inherit (lib.strings) hasPrefix;
  inherit (lib.types) bool listOf package;

  pwCfg = config.services.pipewire;
  cfg = pwCfg.wireplumber;
  pwUsedForAudio = pwCfg.audio.enable;
in
{
  meta.maintainers = [ maintainers.k900 ];

  options = {
    services.pipewire.wireplumber = {
      enable = mkOption {
        type = bool;
        default = pwCfg.enable;
        defaultText = literalExpression "config.services.pipewire.enable";
        description = "Whether to enable WirePlumber, a modular session / policy manager for PipeWire";
      };

      package = mkOption {
        type = package;
        default = pkgs.wireplumber;
        defaultText = literalExpression "pkgs.wireplumber";
        description = "The WirePlumber derivation to use.";
      };

      configPackages = mkOption {
        type = listOf package;
        default = [ ];
        example = literalExpression ''[
          (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" '''
            monitor.bluez.properties = {
              bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
              bluez5.codecs = [ sbc sbc_xq aac ]
              bluez5.enable-sbc-xq = true
              bluez5.hfphsp-backend = "native"
            }
          ''')
        ]'';
        description = ''
          List of packages that provide WirePlumber configuration, in the form of
          `share/wireplumber/*/*.conf` files.

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
          be made available to WirePlumber for [filter chains][wiki-filter-chain].

          Config packages have their required LV2 plugins added automatically,
          so they don't need to be specified here. Config packages need to set
          `passthru.requiredLv2Packages` for this to work.

          [wiki-filter-chain]: https://docs.pipewire.org/page_module_filter_chain.html
        '';
      };
    };
  };

  config =
    let
      pwNotForAudioConfigPkg = pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/90-nixos-no-audio.conf" ''
        # PipeWire is not used for audio, so WirePlumber should not be handling it
        wireplumber.profiles = {
          main = {
            hardware.audio = disabled
            hardware.bluetooth = disabled
          }
        }
      '';

      systemwideConfigPkg = pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/90-nixos-systemwide.conf" ''
        # When running system-wide, we don't have logind to call ReserveDevice,
        # And bluetooth logind integration needs to be disabled
        wireplumber.profiles = {
          main = {
            support.reserve-device = disabled
            monitor.bluez.seat-monitoring = disabled
          }
        }
      '';

      configPackages = cfg.configPackages
          ++ optional (!pwUsedForAudio) pwNotForAudioConfigPkg
          ++ optional pwCfg.systemWide systemwideConfigPkg;

      configs = pkgs.buildEnv {
        name = "wireplumber-configs";
        paths = configPackages;
        pathsToLink = [ "/share/wireplumber" ];
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
        name = "wireplumber-lv2-plugins";
        paths = cfg.extraLv2Packages ++ requiredLv2Packages;
        pathsToLink = [ "/lib/lv2" ];
      };
    in
    mkIf cfg.enable {
      assertions = [
        {
          assertion = !config.hardware.bluetooth.hsphfpd.enable;
          message = "Using WirePlumber conflicts with hsphfpd, as it provides the same functionality. `hardware.bluetooth.hsphfpd.enable` needs be set to false";
        }
        {
          assertion = length
            (attrNames
              (
                filterAttrs
                  (name: value:
                    hasPrefix "wireplumber/" name || name == "wireplumber"
                  )
                  config.environment.etc
              )) == 1;
          message = "Using `environment.etc.\"wireplumber<...>\"` directly is no longer supported in 24.05. Use `services.pipewire.wireplumber.configPackages` instead.";
        }
      ];

      environment.systemPackages = [ cfg.package ];

      environment.etc.wireplumber.source = "${configs}/share/wireplumber";

      systemd.packages = [ cfg.package ];

      systemd.services.wireplumber.enable = pwCfg.systemWide;
      systemd.user.services.wireplumber.enable = !pwCfg.systemWide;

      systemd.services.wireplumber.wantedBy = [ "pipewire.service" ];
      systemd.user.services.wireplumber.wantedBy = [ "pipewire.service" ];

      systemd.services.wireplumber.environment = mkIf pwCfg.systemWide {
        # Force WirePlumber to use system dbus.
        DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/dbus/system_bus_socket";
        LV2_PATH = "${lv2Plugins}/lib/lv2";
      };

      systemd.user.services.wireplumber.environment.LV2_PATH =
        mkIf (!pwCfg.systemWide) "${lv2Plugins}/lib/lv2";
    };
}
