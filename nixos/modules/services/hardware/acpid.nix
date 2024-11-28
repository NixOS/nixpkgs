{ config, lib, pkgs, ... }:
let
  cfg = config.services.acpid;

  canonicalHandlers = {
    powerEvent = {
      event = "button/power.*";
      action = cfg.powerEventCommands;
    };

    lidEvent = {
      event = "button/lid.*";
      action = cfg.lidEventCommands;
    };

    acEvent = {
      event = "ac_adapter.*";
      action = cfg.acEventCommands;
    };
  };

  acpiConfDir = pkgs.runCommand "acpi-events" { preferLocalBuild = true; }
    ''
      mkdir -p $out
      ${
        # Generate a configuration file for each event. (You can't have
        # multiple events in one config file...)
        let f = name: handler:
          ''
            fn=$out/${name}
            echo "event=${handler.event}" > $fn
            echo "action=${pkgs.writeShellScriptBin "${name}.sh" handler.action }/bin/${name}.sh '%e'" >> $fn
          '';
        in lib.concatStringsSep "\n" (lib.mapAttrsToList f (canonicalHandlers // cfg.handlers))
      }
    '';

in

{

  ###### interface

  options = {

    services.acpid = {

      enable = lib.mkEnableOption "the ACPI daemon";

      logEvents = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Log all event activity.";
      };

      handlers = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
            event = lib.mkOption {
              type = lib.types.str;
              example = lib.literalExpression ''"button/power.*" "button/lid.*" "ac_adapter.*" "button/mute.*" "button/volumedown.*" "cd/play.*" "cd/next.*"'';
              description = "Event type.";
            };

            action = lib.mkOption {
              type = lib.types.lines;
              description = "Shell commands to execute when the event is triggered.";
            };
          };
        });

        description = ''
          Event handlers.

          ::: {.note}
          Handler can be a single command.
          :::
        '';
        default = {};
        example = {
          ac-power = {
            event = "ac_adapter/*";
            action = ''
              vals=($1)  # space separated string to array of multiple values
              case ''${vals[3]} in
                  00000000)
                      echo unplugged >> /tmp/acpi.log
                      ;;
                  00000001)
                      echo plugged in >> /tmp/acpi.log
                      ;;
                  *)
                      echo unknown >> /tmp/acpi.log
                      ;;
              esac
            '';
          };
        };
      };

      powerEventCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell commands to execute on a button/power.* event.";
      };

      lidEventCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell commands to execute on a button/lid.* event.";
      };

      acEventCommands = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = "Shell commands to execute on an ac_adapter.* event.";
      };

    };

  };


  ###### implementation

  config = lib.mkIf cfg.enable {

    systemd.services.acpid = {
      description = "ACPI Daemon";
      documentation = [ "man:acpid(8)" ];

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs
          ([ "${pkgs.acpid}/bin/acpid"
             "--foreground"
             "--netlink"
             "--confdir" "${acpiConfDir}"
           ] ++ lib.optional cfg.logEvents "--logevents"
          );
      };
      unitConfig = {
        ConditionVirtualization = "!systemd-nspawn";
        ConditionPathExists = [ "/proc/acpi" ];
      };

    };

  };

}
