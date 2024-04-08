{ config, lib, pkgs, ... }:

let
  pwCfg = config.services.pipewire;
  cfg = pwCfg.wireplumber;
  pwUsedForAudio = pwCfg.audio.enable;
in
{
  meta.maintainers = [ lib.maintainers.k900 ];

  options = {
    services.pipewire.wireplumber = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = config.services.pipewire.enable;
        defaultText = lib.literalExpression "config.services.pipewire.enable";
        description = lib.mdDoc "Whether to enable WirePlumber, a modular session / policy manager for PipeWire";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.wireplumber;
        defaultText = lib.literalExpression "pkgs.wireplumber";
        description = lib.mdDoc "The WirePlumber derivation to use.";
      };

      configPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = lib.mdDoc ''
          List of packages that provide WirePlumber configuration, in the form of
          `share/wireplumber/*/*.lua` files.

          LV2 dependencies will be picked up from config packages automatically
          via `passthru.requiredLv2Packages`.
        '';
      };

      extraLv2Packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [];
        example = lib.literalExpression "[ pkgs.lsp-plugins ]";
        description = lib.mdDoc ''
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
          ++ lib.optional (!pwUsedForAudio) pwNotForAudioConfigPkg
          ++ lib.optional config.services.pipewire.systemWide systemwideConfigPkg;

      configs = pkgs.buildEnv {
        name = "wireplumber-configs";
        paths = configPackages;
        pathsToLink = [ "/share/wireplumber" ];
      };

      requiredLv2Packages = lib.flatten
        (
          lib.concatMap
            (p:
              lib.attrByPath ["passthru" "requiredLv2Packages"] [] p
            )
            configPackages
        );

      lv2Plugins = pkgs.buildEnv {
        name = "wireplumber-lv2-plugins";
        paths = cfg.extraLv2Packages ++ requiredLv2Packages;
        pathsToLink = [ "/lib/lv2" ];
      };
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = !config.hardware.bluetooth.hsphfpd.enable;
          message = "Using WirePlumber conflicts with hsphfpd, as it provides the same functionality. `hardware.bluetooth.hsphfpd.enable` needs be set to false";
        }
        {
          assertion = builtins.length
            (builtins.attrNames
              (
                lib.filterAttrs
                  (name: value:
                    lib.hasPrefix "wireplumber/" name || name == "wireplumber"
                  )
                  config.environment.etc
              )) == 1;
          message = "Using `environment.etc.\"wireplumber<...>\"` directly is no longer supported in 24.05. Use `services.pipewire.wireplumber.configPackages` instead.";
        }
      ];

      environment.systemPackages = [ cfg.package ];

      environment.etc.wireplumber.source = "${configs}/share/wireplumber";

      systemd.packages = [ cfg.package ];

      systemd.services.wireplumber.enable = config.services.pipewire.systemWide;
      systemd.user.services.wireplumber.enable = !config.services.pipewire.systemWide;

      systemd.services.wireplumber.wantedBy = [ "pipewire.service" ];
      systemd.user.services.wireplumber.wantedBy = [ "pipewire.service" ];

      systemd.services.wireplumber.environment = lib.mkIf config.services.pipewire.systemWide {
        # Force WirePlumber to use system dbus.
        DBUS_SESSION_BUS_ADDRESS = "unix:path=/run/dbus/system_bus_socket";
        LV2_PATH = "${lv2Plugins}/lib/lv2";
      };

      systemd.user.services.wireplumber.environment.LV2_PATH =
        lib.mkIf (!config.services.pipewire.systemWide) "${lv2Plugins}/lib/lv2";
    };
}
