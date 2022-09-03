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
      enable = mkEnableOption (lib.mdDoc "Klipper, the 3D printer firmware");

      package = mkOption {
        type = types.package;
        default = pkgs.klipper;
        defaultText = literalExpression "pkgs.klipper";
        description = lib.mdDoc "The Klipper package.";
      };

      inputTTY = mkOption {
        type = types.path;
        default = "/run/klipper/tty";
        description = lib.mdDoc "Path of the virtual printer symlink to create.";
      };

      apiSocket = mkOption {
        type = types.nullOr types.path;
        default = "/run/klipper/api";
        description = lib.mdDoc "Path of the API socket to create.";
      };

      octoprintIntegration = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Allows Octoprint to control Klipper.";
      };

      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          User account under which Klipper runs.

          If null is specified (default), a temporary user will be created by systemd.
        '';
      };

      group = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          Group account under which Klipper runs.

          If null is specified (default), a temporary user will be created by systemd.
        '';
      };

      settings = mkOption {
        type = format.type;
        default = { };
        description = lib.mdDoc ''
          Configuration for Klipper. See the [documentation](https://www.klipper3d.org/Overview.html#configuration-and-tuning-guides)
          for supported values.
        '';
      };

      firmwares = mkOption {
        description = lib.mdDoc "Firmwares klipper should manage";
        default = { };
        type = with types; attrsOf
          (submodule {
            options = {
              enable = mkEnableOption (lib.mdDoc ''
                building of firmware and addition of klipper-flash tools for manual flashing.
                This will add `klipper-flash-$mcu` scripts to your environment which can be called to flash the firmware.
              '');
              configFile = mkOption {
                type = path;
                description = lib.mdDoc "Path to firmware config which is generated using `klipper-genconf`";
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
        message = "Option klipper.octoprintIntegration requires Octoprint to be enabled on this system. Please enable services.octoprint to use it.";
      }
      {
        assertion = cfg.user != null -> cfg.group != null;
        message = "Option klipper.group is not set when a user is specified.";
      }
      {
        assertion = foldl (a: b: a && b) true (mapAttrsToList (mcu: _: mcu != null -> (hasAttrByPath [ "${mcu}" "serial" ] cfg.settings)) cfg.firmwares);
        message = "Option klipper.settings.$mcu.serial must be set when klipper.firmware.$mcu is specified";
      }
    ];

    environment.etc."klipper.cfg".source = format.generate "klipper.cfg" cfg.settings;

    services.klipper = mkIf cfg.octoprintIntegration {
      user = config.services.octoprint.user;
      group = config.services.octoprint.group;
    };

    systemd.services.klipper =
      let
        klippyArgs = "--input-tty=${cfg.inputTTY}"
          + optionalString (cfg.apiSocket != null) " --api-server=${cfg.apiSocket}";
      in
      {
        description = "Klipper 3D Printer Firmware";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${cfg.package}/lib/klipper/klippy.py ${klippyArgs} /etc/klipper.cfg";
          RuntimeDirectory = "klipper";
          SupplementaryGroups = [ "dialout" ];
          WorkingDirectory = "${cfg.package}/lib";
          OOMScoreAdjust = "-999";
          CPUSchedulingPolicy = "rr";
          CPUSchedulingPriority = 99;
          IOSchedulingClass = "realtime";
          IOSchedulingPriority = 0;
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
        firmwares = filterAttrs (n: v: v!= null) (mapAttrs
          (mcu: { enable, configFile }: if enable then pkgs.klipper-firmware.override {
            mcu = lib.strings.sanitizeDerivationName mcu;
            firmwareConfig = configFile;
          } else null)
          cfg.firmwares);
        firmwareFlasher = mapAttrsToList
          (mcu: firmware: pkgs.klipper-flash.override {
            mcu = lib.strings.sanitizeDerivationName mcu;
            klipper-firmware = firmware;
            flashDevice = cfg.settings."${mcu}".serial;
            firmwareConfig = cfg.firmwares."${mcu}".configFile;
          })
          firmwares;
      in
      [ klipper-genconf ] ++ firmwareFlasher ++ attrValues firmwares;
  };
}
