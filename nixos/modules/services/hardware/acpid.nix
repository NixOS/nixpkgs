{ config, lib, pkgs, ... }:

with lib;

let
  stage1Cfg = config.boot.initrd.services.acpid;
  stage2Cfg = config.services.acpid;

  # Created as a single derivation for simpler use in initrd
  mkAcpiHandlers = handlers: let
    mkScript = name: handler: ''
      echo ${lib.escapeShellArg handler.action} > "$out/scripts/${name}.sh"
      chmod +x "$out/scripts/${name}.sh"
    '';

    mkHandler = name: handler: ''
      echo "event=${handler.event}" > "$out/handlers/${name}"
      echo "action=$out/scripts/${name}.sh" >> "$out/handlers/${name}"
    '';
  in pkgs.runCommand "acpi-events" { preferLocalBuild = true; } ''
    mkdir -p $out/scripts
    mkdir -p $out/handlers
    ${concatStringsSep "\n" (mapAttrsToList mkScript handlers)}
    ${concatStringsSep "\n" (mapAttrsToList mkHandler handlers)}
  '';

  acpiConfFor = cfg: let
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
  in mkAcpiHandlers ((lib.filterAttrs (_: handler: handler.action != "") canonicalHandlers) // cfg.handlers);

  options = stage2: {
    enable = mkEnableOption (lib.mdDoc "the ACPI daemon");
    package = mkPackageOption pkgs "acpid" {};

    logEvents = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Log all event activity";
    };

    handlers = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          event = mkOption {
            type = types.str;
            description = lib.mdDoc (''
              Event type
            '' + lib.optionalString (!stage2) ''

              ::: {.note}
              Many events will require kernel modules to be available via `boot.initrd.availableKernelModules`.
              :::
            '');

            example = literalExpression ''
              "button/power.*" "button/lid.*" "ac_adapter.*" "button/mute.*" "button/volumedown.*" "cd/play.*" "cd/next.*"
            '';
          };

          action = mkOption {
            type = types.lines;
            description = "Shell commands to execute when the event is triggered";
          };
        };
      });

      description = lib.mdDoc ''
        Event handlers

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

    powerEventCommands = mkOption {
      type = types.lines;
      default = "";
      description = "Shell commands to execute on a button/power.* event";
    };

    lidEventCommands = mkOption {
      type = types.lines;
      default = "";
      description = "Shell commands to execute on a button/lid.* event";
    };

    acEventCommands = mkOption {
      type = types.lines;
      default = "";
      description = "Shell commands to execute on an ac_adapter.* event";
    };
  };

  mkConfig = cfg: mkIf cfg.enable {
    systemd.services.acpid = {
      description = "ACPI Daemon";
      documentation = [ "man:acpid(8)" ];

      # Acpid requires /var/run to exist but dosen't create it, and no systemd service seems to create it either.
      # Note this is only a problem for stage1.
      script = ''
        ln -s /run /var/run || true

        ${cfg.package}/bin/acpid \
          --foreground \
          --netlink \
          --confdir "${acpiConfFor cfg}/handlers" \
          ${lib.optionalString cfg.logEvents "--logevents"}
      '';

      unitConfig = {
        ConditionVirtualization = "!systemd-nspawn";
        ConditionPathExists = [ "/proc/acpi" ];
      };
    };
  };
in {
  options = {
    services.acpid = options true;
    boot.initrd.services.acpid = options false;
  };

  config = mkMerge [
    (mkConfig stage2Cfg)
    { boot.initrd = mkConfig stage1Cfg; }

    (mkIf stage2Cfg.enable {
      systemd.services.acpid.wantedBy = [ "multi-user.target" ];
    })

    (mkIf stage1Cfg.enable {
      assertions = [ {
        assertion = config.boot.initrd.systemd.enable;
        message = "the acpid module only works with systemd based initrd";
      } ];

      boot.initrd = {
        # Add the kernel modules required by each canonical command type if present
        availableKernelModules = mkMerge [
          (mkIf (stage1Cfg.powerEventCommands != "" || stage1Cfg.lidEventCommands != "") [ "button" ])
          (mkIf (stage1Cfg.acEventCommands != "") [ "ac" ])
        ];

        systemd = {
          initrdBin = [ stage1Cfg.package ];
          storePaths = [ (acpiConfFor stage1Cfg) ];

          services.acpid.wantedBy = [ "initrd.target" ];
        };
      };
    })
  ];
}
