{ config, lib, pkgs, ... }:

let
  inherit (builtins) attrNames concatMap length;
  inherit (lib) maintainers;
  inherit (lib.attrsets) attrByPath filterAttrs mapAttrsToList attrsToList concatMapAttrs;
  inherit (lib.lists) flatten optional;
  inherit (lib.modules) mkIf;
  inherit (lib.options) literalExpression mkOption;
  inherit (lib.strings) hasPrefix concatMapStringsSep concatStringsSep;
  inherit (lib.types) bool listOf attrsOf package lines;

  pwCfg = config.services.pipewire;
  cfg = pwCfg.wireplumber;
  pwUsedForAudio = pwCfg.audio.enable;

  json = pkgs.formats.json {};

  mapConfigToFiles = location: ext: writeFn: config:
    concatMapAttrs
      (name: value: {
        "share/wireplumber/${location}/${name}.${ext}" = writeFn name value;
      })
      config;

  configSectionsToConfFile = name: value:
    pkgs.writeText
      name
      (concatStringsSep "\n" (
        mapAttrsToList
          (section: content: "${section} = " + (builtins.toJSON content))
          value
      ));

  extraConfigPkgFromFiles = locations: filesSet: pkgs.runCommand "wireplumber-extra-config" { } ''
    mkdir -p ${concatMapStringsSep " " (l: "$out/share/wireplumber/${l}") locations}
    ${concatMapStringsSep ";" ({name, value}: "ln -s ${value} $out/${name}") (attrsToList filesSet)}
  '';
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

      extraConfig = mkOption {
        # Two layer attrset is necessary before using JSON, because of the whole
        # config file not being a JSON object, but a concatenation of JSON objects
        # in sections.
        type = attrsOf (attrsOf json.type);
        default = { };
        example = literalExpression ''{
          "log-level-debug" = {
            "context.properties" = {
              # Output Debug log messages as opposed to only the default level (Notice)
              "log.level" = "D";
            };
          };
          "wh-1000xm3-ldac-hq" = {
            "monitor.bluez.rules" = [
              {
                matches = [
                  {
                    # Match any bluetooth device with ids equal to that of a WH-1000XM3
                    "device.name" = "~bluez_card.*";
                    "device.product.id" = "0x0cd3";
                    "device.vendor.id" = "usb:054c";
                  }
                ];
                actions = {
                  update-props = {
                    # Set quality to high quality instead of the default of auto
                    "bluez5.a2dp.ldac.quality" = "hq";
                  };
                };
              }
            ];
          };
        }'';
        description = ''
          Additional configuration for the WirePlumber daemon when run in
          single-instance mode (the default in nixpkgs and currently the only
          supported way to run WirePlumber configured via `extraConfig`).

          See also:
          - [The configuration file][docs-the-conf-file]
          - [Modifying configuration][docs-modifying-config]
          - [Locations of files][docs-file-locations]
          - and the [configuration section][docs-config-section] of the docs in general

          Note that WirePlumber (and PipeWire) use dotted attribute names like
          `device.product.id`. These are not nested, but flat objects for WirePlumber/PipeWire,
          so to write these in nix expressions, remember to quote them like `"device.product.id"`.
          Have a look at the example for this.

          [docs-the-conf-file]: https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration/conf_file.html
          [docs-modifying-config]: https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration/modifying_configuration.html
          [docs-file-locations]: https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration/locations.html
          [docs-config-section]: https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration.html
        '';
      };

      extraScripts = mkOption {
        type = attrsOf lines;
        default = { };
        description = ''
          Additional scripts for WirePlumber to be used by configuration files.

          Every item in this attrset becomes a separate lua file `/etc/wireplumber/scripts`.

          See also:
          - [Location of files][docs-file-locations]

          [docs-file-locations]: https://pipewire.pages.freedesktop.org/wireplumber/daemon/configuration/locations.html
        '';
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

      extraConfigPkg = extraConfigPkgFromFiles
        [ "wireplumber.conf.d" "scripts" ]
        (
          mapConfigToFiles "wireplumber.conf.d" "conf" (configSectionsToConfFile) cfg.extraConfig
          // mapConfigToFiles "scripts" "lua" (pkgs.writeText) cfg.extraScripts
        );

      configPackages = cfg.configPackages
          ++ [ extraConfigPkg ]
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
          message = "Using `environment.etc.\"wireplumber<...>\"` directly is no longer supported in 24.05. Use `extraConfig`, `extraScripts`, or `configPackages` in `services.pipewire.wireplumber` instead.";
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
