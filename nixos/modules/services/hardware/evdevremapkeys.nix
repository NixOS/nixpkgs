{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.evdevremapkeys;

  fullConfig = {
    devices = cfg.devices;
  };

  cfgFile = pkgs.writeText "config.yaml" (builtins.toJSON fullConfig);
in {

  options.services.evdevremapkeys = {

    # Note: this corresponds to the YAML configuration that evdevremap keys
    # expects.
    devices = mkOption {
      default = {};
      description = "Input devices to remap using evdevremapkeys";
      type = with types; listOf (submodule {
        options = {

          input_name = mkOption {
            type = str;
            description = ''
              Name of device to be remapped (from `xinput list`).
            '';
          };

          output_name = mkOption {
            type = str;
            description = ''
              Name of virtual device that will output remapped events.
            '';
          };

          remappings = mkOption {
            type = attrsOf (listOf str);
            description = ''
              Attrset of inputted event name to list of events that will be
              fired instead. The event names are standard Linux input event
              names, for a list see include/uapi/linux/input-event-codes.h in
              the Linux source tree.

              For example:
                remappings = {
                  KEY_ESC = [
                    "KEY_A"
                    "KEY_B"
                  ];
                };
              will remap the escape key to instead fire an A and B keypress
              simultaneously when pressed.
            '';
          };
        };
      });
    };

  };

  config = mkIf (cfg.devices != []) {

    systemd.services.evdevremapkeys = {
      description = "Remap Evdev Input";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.evdevremapkeys}/bin/evdevremapkeys -f ${cfgFile}";
        WorkingDirectory = "/tmp";
        Restart = "always";
        PrivateTmp = true;
        NoNewPrivileges = true;
      };
    };

  };

  meta.maintainers = with maintainers; [ maintainers.q3k ];
}
