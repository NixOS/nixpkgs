{ config, lib, pkgs, ... }:

with lib;

let

  canonicalHandlers = {
    powerEvent = {
      event = "button/power.*";
      action = config.services.acpid.powerEventCommands;
    };

    lidEvent = {
      event = "button/lid.*";
      action = config.services.acpid.lidEventCommands;
    };

    acEvent = {
      event = "ac_adapter.*";
      action = config.services.acpid.acEventCommands;
    };
  };

  acpiConfDir = pkgs.runCommand "acpi-events" {}
    ''
      mkdir -p $out
      ${
        # Generate a configuration file for each event. (You can't have
        # multiple events in one config file...)
        let f = name: handler:
          ''
            fn=$out/${name}
            echo "event=${handler.event}" > $fn
            echo "action=${pkgs.writeScript "${name}.sh" (concatStringsSep "\n" [ "#! ${pkgs.bash}/bin/sh" handler.action ])}" >> $fn
          '';
        in concatStringsSep "\n" (mapAttrsToList f (canonicalHandlers // config.services.acpid.handlers))
      }
    '';

in

{

  ###### interface

  options = {

    services.acpid = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the ACPI daemon.";
      };

      handlers = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            event = mkOption {
              type = types.str;
              example = [ "button/power.*" "button/lid.*" "ac_adapter.*" "button/mute.*" "button/volumedown.*" "cd/play.*" "cd/next.*" ];
              description = "Event type.";
            };

            action = mkOption {
              type = types.lines;
              description = "Shell commands to execute when the event is triggered.";
            };
          };
        });

        description = "Event handlers.";
        default = {};
        example = { mute = { event = "button/mute.*"; action = "amixer set Master toggle"; }; };


      };

      powerEventCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to execute on a button/power.* event.";
      };

      lidEventCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to execute on a button/lid.* event.";
      };

      acEventCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to execute on an ac_adapter.* event.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.acpid.enable {

    systemd.services.acpid = {
      description = "ACPI Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];

      path = [ pkgs.acpid ];

      serviceConfig = {
        Type = "forking";
      };

      unitConfig = {
        ConditionVirtualization = "!systemd-nspawn";
        ConditionPathExists = [ "/proc/acpi" ];
      };

      script = "acpid --confdir ${acpiConfDir}";
    };

  };

}
