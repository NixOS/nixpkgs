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
  firmwareSubmodule = lib.types.submodule (
    { name, ... }@local:
    let
      mcu = local.name;
      subcfg = local.config;
    in
    {
      options = {
        enable = lib.mkEnableOption ''
          building of firmware for manual flashing
        '';
        enableKlipperFlash = lib.mkEnableOption ''
          flashings scripts for firmware. This will add `klipper-flash-$mcu` scripts to your environment which can be called to flash the firmware.
          Please check the configs at [klipper](https://github.com/Klipper3d/klipper/tree/master/config) whether your board supports flashing via `make flash`
        '';
        serial = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          description = "Path to serial port this printer is connected to. Derived from `service.klipper.settings` by default.";
          defaultText = lib.literalExpression "config.services.klipper.settings.<name>.serial";
          default =
            if lib.hasAttrByPath [ "${mcu}" "serial" ] cfg.settings then cfg.settings."${mcu}".serial else null;
        };
        configFile = lib.mkOption {
          type = lib.types.path;
          description = "Path to firmware config which is generated using `klipper-genconf`";
        };
        package = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          readOnly = true;
          description = "Path to the built firmware package.";
        };
        klipperFlashPackage = lib.mkOption {
          type = lib.types.nullOr lib.types.package;
          readOnly = true;
          description = "Path to the built klipper-flash package.";
        };
      };
      config = {
        package =
          if subcfg.enable then
            pkgs.klipper-firmware.override {
              klipper = cfg.package;
              mcu = lib.strings.sanitizeDerivationName mcu;
              firmwareConfig = subcfg.configFile;
            }
          else
            null;

        klipperFlashPackage =
          if subcfg.enable && subcfg.enableKlipperFlash then
            pkgs.klipper-flash.override {
              klipper = cfg.package;
              klipper-firmware = subcfg.package;
              mcu = lib.strings.sanitizeDerivationName mcu;
              flashDevice = subcfg.serial;
              firmwareConfig = subcfg.configFile;
            }
          else
            null;
      };
    }
  );
in
{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "klipper" "mutableConfigFolder" ]
      [ "services" "klipper" "configDir" ]
    )
  ];

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
          Whether to manage the config outside of NixOS.

          It will still be initialized with the defined NixOS config if the file doesn't already exist.
        '';
      };

      configDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/klipper";
        description = "Path to Klipper config file.";
      };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to default Klipper config.";
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

      extraSettings = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Extra lines to append to the generated Klipper configuration.";
      };

      firmwares = lib.mkOption {
        description = "Firmwares Klipper should manage";
        default = { };
        type = lib.types.attrsOf firmwareSubmodule;
        example = {
          mcu = {
            enable = true;
            enableKlipperFlash = true;
            serial = "/dev/serial/by-id/usb-Klipper_123ABCDEF";
            configFile = lib.literalExpression "./klipper-firmware.cfg";
          };
        };
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
        assertion = (cfg.configFile != null) != (cfg.settings != null);
        message = "You need to either specify services.klipper.settings or services.klipper.configFile.";
      }
      {
        assertion = (cfg.configFile != null) -> (cfg.extraSettings == "");
        message = "You can't use services.klipper.extraSettings with services.klipper.configFile.";
      }
    ]
    ++ lib.mapAttrsToList (mcu: firmware: {
      assertion = firmware.enableKlipperFlash -> firmware.serial != null;
      message = ''
        Unable to determine the serial connection for services.klipper.firmwares."${mcu}". Please set one of the following:

          - services.klipper.firmwares."${mcu}".serial
          - services.klipper.settings."${mcu}".serial
      '';
    }) cfg.firmwares;

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
        printerConfig =
          if cfg.settings != null then
            builtins.toFile "klipper.cfg" ((format.generate "" cfg.settings).text + cfg.extraSettings)
          else
            cfg.configFile;
      in
      {
        description = "Klipper 3D Printer Firmware";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        preStart = ''
          mkdir -p ${cfg.configDir}
          pushd ${cfg.configDir}
          if [ -e printer.cfg ]; then
            ${
              if cfg.mutableConfig then
                ":"
              else
                ''
                  # Backup existing config using the same date format klipper uses for SAVE_CONFIG
                  old_config="printer-$(date +"%Y%m%d_%H%M%S").cfg"
                  mv printer.cfg "$old_config"
                  # Preserve SAVE_CONFIG section from the existing config
                  cat ${printerConfig} <(printf "\n") <(sed -n '/#*# <---------------------- SAVE_CONFIG ---------------------->/,$p' "$old_config") > printer.cfg
                  ${pkgs.diffutils}/bin/cmp printer.cfg "$old_config" && rm "$old_config"
                ''
            }
          else
            cat ${printerConfig} > printer.cfg
          fi
          popd
        '';

        restartTriggers = lib.optional (!cfg.mutableConfig) [ printerConfig ];

        serviceConfig = {
          ExecStart = "${cfg.package}/bin/klippy ${klippyArgs} ${cfg.configDir}/printer.cfg";
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
      let
        default = a: b: if a != null then a else b;
        genconf = pkgs.klipper-genconf.override {
          klipper = cfg.package;
        };
        firmwares = lib.filter (v: v != null) (
          lib.mapAttrsToList (mcu: firmware: firmware.package) cfg.firmwares
        );
        firmwareFlashers = lib.filter (v: v != null) (
          lib.mapAttrsToList (mcu: firmware: firmware.klipperFlashPackage) cfg.firmwares
        );
      in
      [ genconf ] ++ firmwares ++ firmwareFlashers;
  };
  meta.maintainers = [
    lib.maintainers.cab404
  ];
}
