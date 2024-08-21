{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.klipper;
  format = pkgs.formats.ini {
    # https://github.com/NixOS/nixpkgs/pull/121613#issuecomment-885241996
    listToValue = l:
      if builtins.length l == 1 then generators.mkValueStringDefault { } (head l)
      else lib.concatMapStrings (s: "\n  ${generators.mkValueStringDefault {} s}") l;
    mkKeyValue = generators.mkKeyValueDefault { } ":";
  };
in
{
  ##### interface
  options = {
    services.klipper = {
      enable = mkEnableOption "Klipper, the 3D printer firmware";

      package = mkPackageOption pkgs "klipper" { };

      logFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/var/lib/klipper/klipper.log";
        description = ''
          Path of the file Klipper should log to.
          If `null`, it logs to stdout, which is not recommended by upstream.
        '';
      };

      inputTTY = mkOption {
        type = types.path;
        default = "/run/klipper/tty";
        description = "Path of the virtual printer symlink to create.";
      };

      apiSocket = mkOption {
        type = types.nullOr types.path;
        default = "/run/klipper/api";
        description = "Path of the API socket to create.";
      };

      mutableConfig = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to copy the config to a mutable directory instead of using the one directly from the nix store.
          This will only copy the config if the file at `services.klipper.mutableConfigPath` doesn't exist.
        '';
      };

      mutableConfigFolder = mkOption {
        type = types.path;
        default = "/var/lib/klipper";
        description = "Path to mutable Klipper config file.";
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to default Klipper config.
        '';
      };

      octoprintIntegration = mkOption {
        type = types.bool;
        default = false;
        description = "Allows Octoprint to control Klipper.";
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          User account under which Klipper runs.

          If null is specified (default), a temporary user will be created by systemd.
        '';
      };

      group = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Group account under which Klipper runs.

          If null is specified (default), a temporary user will be created by systemd.
        '';
      };

      settings = mkOption {
        type = types.nullOr format.type;
        default = null;
        description = ''
          Configuration for Klipper. See the [documentation](https://www.klipper3d.org/Overview.html#configuration-and-tuning-guides)
          for supported values.
        '';
      };

      firmwares = mkOption {
        description = "Firmwares klipper should manage";
        default = { };
        type = with types; attrsOf
          (submodule {
            options = {
              enable = mkEnableOption ''
                building of firmware for manual flashing
              '';
              enableKlipperFlash = mkEnableOption ''
                flashings scripts for firmware. This will add `klipper-flash-$mcu` scripts to your environment which can be called to flash the firmware.
                Please check the configs at [klipper](https://github.com/Klipper3d/klipper/tree/master/config) whether your board supports flashing via `make flash`
              '';
              serial = mkOption {
                type = types.nullOr path;
                description = "Path to serial port this printer is connected to. Leave `null` to derive it from `service.klipper.settings`.";
              };
              configFile = mkOption {
                type = path;
                description = "Path to firmware config which is generated using `klipper-genconf`";
              };
            };
          });
      };
    };
  };

  ##### implementation
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.octoprintIntegration -> config.services.octoprint.enable;
        message = "Option services.klipper.octoprintIntegration requires Octoprint to be enabled on this system. Please enable services.octoprint to use it.";
      }
      {
        assertion = cfg.user != null -> cfg.group != null;
        message = "Option services.klipper.group is not set when services.klipper.user is specified.";
      }
      {
        assertion = cfg.settings != null -> foldl (a: b: a && b) true (mapAttrsToList (mcu: _: mcu != null -> (hasAttrByPath [ "${mcu}" "serial" ] cfg.settings)) cfg.firmwares);
        message = "Option services.klipper.settings.$mcu.serial must be set when settings.klipper.firmware.$mcu is specified";
      }
      {
        assertion = (cfg.configFile != null) != (cfg.settings != null);
        message = "You need to either specify services.klipper.settings or services.klipper.configFile.";
      }
    ];

    environment.etc = mkIf (!cfg.mutableConfig) {
      "klipper.cfg".source = if cfg.settings != null then format.generate "klipper.cfg" cfg.settings else cfg.configFile;
    };

    services.klipper = mkIf cfg.octoprintIntegration {
      user = config.services.octoprint.user;
      group = config.services.octoprint.group;
    };

    systemd.services.klipper =
      let
        klippyArgs = "--input-tty=${cfg.inputTTY}"
          + optionalString (cfg.apiSocket != null) " --api-server=${cfg.apiSocket}"
          + optionalString (cfg.logFile != null) " --logfile=${cfg.logFile}"
        ;
        printerConfigPath =
          if cfg.mutableConfig
          then cfg.mutableConfigFolder + "/printer.cfg"
          else "/etc/klipper.cfg";
        printerConfigFile =
          if cfg.settings != null
          then format.generate "klipper.cfg" cfg.settings
          else cfg.configFile;
      in
      {
        description = "Klipper 3D Printer Firmware";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        preStart = ''
          mkdir -p ${cfg.mutableConfigFolder}
          ${lib.optionalString (cfg.mutableConfig) ''
            [ -e ${printerConfigPath} ] || {
              cp ${printerConfigFile} ${printerConfigPath}
              chmod +w ${printerConfigPath}
            }
          ''}
          mkdir -p ${cfg.mutableConfigFolder}/gcodes
        '';

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/klippy ${klippyArgs} ${printerConfigPath}";
          RuntimeDirectory = "klipper";
          StateDirectory = "klipper";
          SupplementaryGroups = [ "dialout" ];
          WorkingDirectory = "${cfg.package}/lib";
          OOMScoreAdjust = "-999";
          CPUSchedulingPolicy = "rr";
          CPUSchedulingPriority = 99;
          IOSchedulingClass = "realtime";
          IOSchedulingPriority = 0;
          UMask = "0002";
        } // (if cfg.user != null then {
          Group = cfg.group;
          User = cfg.user;
        } else {
          DynamicUser = true;
          User = "klipper";
        });
      };

    environment.systemPackages =
      with pkgs;
      let
        default = a: b: if a != null then a else b;
        firmwares = filterAttrs (n: v: v != null) (mapAttrs
          (mcu: { enable, enableKlipperFlash, configFile, serial }:
            if enable then
              pkgs.klipper-firmware.override
                {
                  mcu = lib.strings.sanitizeDerivationName mcu;
                  firmwareConfig = configFile;
                } else null)
          cfg.firmwares);
        firmwareFlasher = mapAttrsToList
          (mcu: firmware: pkgs.klipper-flash.override {
            mcu = lib.strings.sanitizeDerivationName mcu;
            klipper-firmware = firmware;
            flashDevice = default cfg.firmwares."${mcu}".serial cfg.settings."${mcu}".serial;
            firmwareConfig = cfg.firmwares."${mcu}".configFile;
          })
          (filterAttrs (mcu: firmware: cfg.firmwares."${mcu}".enableKlipperFlash) firmwares);
      in
      [ klipper-genconf ] ++ firmwareFlasher ++ attrValues firmwares;
  };
  meta.maintainers = [
    maintainers.cab404
  ];
}
