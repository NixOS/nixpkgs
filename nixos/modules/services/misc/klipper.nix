{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.klipper;
  format = pkgs.formats.ini {
    # https://github.com/NixOS/nixpkgs/pull/121613#issuecomment-885241996
    listToValue =
      l:
      if builtins.length l == 1 then
        lib.generators.mkValueStringDefault { } (lib.head l)
      else
        lib.concatMapStrings (s: "\n  ${lib.generators.mkValueStringDefault { } s}") l;
    mkKeyValue = lib.generators.mkKeyValueDefault { } ":";
  };
in
{
  ##### interface
  options = {
    services.klipper = {
      enable = lib.mkEnableOption "Klipper, the 3D printer firmware";

      package = lib.mkPackageOption pkgs "klipper" { };

      logFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/var/lib/klipper/klipper.log";
        description = ''
          Path of the file Klipper should log to.
          If `null`, it logs to stdout, which is not recommended by upstream.
        '';
      };

      inputTTY = lib.mkOption {
        type = lib.types.path;
        default = "/run/klipper/tty";
        description = "Path of the virtual printer symlink to create.";
      };

      apiSocket = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = "/run/klipper/api";
        description = "Path of the API socket to create.";
      };

      mutableConfig = lib.mkOption {
        type = lib.types.bool;
        default = false;
        example = true;
        description = ''
          Whether to copy the config to a mutable directory instead of using the one directly from the nix store.
          This will only copy the config if the file at `services.klipper.mutableConfigPath` doesn't exist.
        '';
      };

      mutableConfigFolder = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/klipper";
        description = "Path to mutable Klipper config file.";
      };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to default Klipper config.
        '';
      };

      octoprintIntegration = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Allows Octoprint to control Klipper.";
      };

      user = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          User account under which Klipper runs.

          If null is specified (default), a temporary user will be created by systemd.
        '';
      };

      group = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Group account under which Klipper runs.

          If null is specified (default), a temporary user will be created by systemd.
        '';
      };

      settings = lib.mkOption {
        type = lib.types.nullOr format.type;
        default = null;
        description = ''
          Configuration for Klipper. See the [documentation](https://www.klipper3d.org/Overview.html#configuration-and-tuning-guides)
          for supported values.
        '';
      };

      firmwares = lib.mkOption {
        description = "Firmwares klipper should manage";
        default = { };
        type =
          with lib.types;
          attrsOf (submodule {
            options = {
              enable = lib.mkEnableOption ''
                building of firmware for manual flashing
              '';
              enableKlipperFlash = lib.mkEnableOption ''
                flashings scripts for firmware. This will add `klipper-flash-$mcu` scripts to your environment which can be called to flash the firmware.
                Please check the configs at [klipper](https://github.com/Klipper3d/klipper/tree/master/config) whether your board supports flashing via `make flash`
              '';
              serial = lib.mkOption {
                type = lib.types.nullOr path;
                default = null;
                description = "Path to serial port this printer is connected to. Leave `null` to derive it from `service.klipper.settings`.";
              };
              configFile = lib.mkOption {
                type = path;
                description = "Path to firmware config which is generated using `klipper-genconf`";
              };
            };
          });
      };
    };
  };

  ##### implementation
  config = lib.mkIf cfg.enable {
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
        assertion =
          cfg.settings != null
          -> lib.foldl (a: b: a && b) true (
            lib.mapAttrsToList (
              mcu: _: mcu != null -> (lib.hasAttrByPath [ "${mcu}" "serial" ] cfg.settings)
            ) cfg.firmwares
          );
        message = "Option services.klipper.settings.$mcu.serial must be set when settings.klipper.firmware.$mcu is specified";
      }
      {
        assertion = (cfg.configFile != null) != (cfg.settings != null);
        message = "You need to either specify services.klipper.settings or services.klipper.configFile.";
      }
    ];

    environment.etc = lib.mkIf (!cfg.mutableConfig) {
      "klipper.cfg".source =
        if cfg.settings != null then format.generate "klipper.cfg" cfg.settings else cfg.configFile;
    };

    services.klipper = lib.mkIf cfg.octoprintIntegration {
      user = config.services.octoprint.user;
      group = config.services.octoprint.group;
    };

    systemd.services.klipper =
      let
        klippyArgs =
          "--input-tty=${cfg.inputTTY}"
          + lib.optionalString (cfg.apiSocket != null) " --api-server=${cfg.apiSocket}"
          + lib.optionalString (cfg.logFile != null) " --logfile=${cfg.logFile}";
        printerConfigPath =
          if cfg.mutableConfig then cfg.mutableConfigFolder + "/printer.cfg" else "/etc/klipper.cfg";
        printerConfigFile =
          if cfg.settings != null then format.generate "klipper.cfg" cfg.settings else cfg.configFile;
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

        serviceConfig =
          {
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
          }
          // (
            if cfg.user != null then
              {
                Group = cfg.group;
                User = cfg.user;
              }
            else
              {
                DynamicUser = true;
                User = "klipper";
              }
          );
      };

    environment.systemPackages =
      with pkgs;
      let
        default = a: b: if a != null then a else b;
        firmwares = lib.filterAttrs (n: v: v != null) (
          lib.mapAttrs (
            mcu:
            {
              enable,
              enableKlipperFlash,
              configFile,
              serial,
            }:
            if enable then
              pkgs.klipper-firmware.override {
                mcu = lib.strings.sanitizeDerivationName mcu;
                firmwareConfig = configFile;
              }
            else
              null
          ) cfg.firmwares
        );
        firmwareFlasher = lib.mapAttrsToList (
          mcu: firmware:
          pkgs.klipper-flash.override {
            mcu = lib.strings.sanitizeDerivationName mcu;
            klipper-firmware = firmware;
            flashDevice = default cfg.firmwares."${mcu}".serial cfg.settings."${mcu}".serial;
            firmwareConfig = cfg.firmwares."${mcu}".configFile;
          }
        ) (lib.filterAttrs (mcu: firmware: cfg.firmwares."${mcu}".enableKlipperFlash) firmwares);
      in
      [ klipper-genconf ] ++ firmwareFlasher ++ lib.attrValues firmwares;
  };
  meta.maintainers = [
    lib.maintainers.cab404
  ];
}
