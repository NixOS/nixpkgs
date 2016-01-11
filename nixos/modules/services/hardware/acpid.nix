{ config, lib, pkgs, ... }:

with lib;

let

  acpiConfDir = pkgs.runCommand "acpi-events" {}
    ''
      mkdir -p $out
      ${
        # Generate a configuration file for each event. (You can't have
        # multiple events in one config file...)
        let f = event:
          ''
            fn=$out/${event.name}
            echo "event=${event.event}" > $fn
            echo "action=${pkgs.writeScript "${event.name}.sh" event.action}" >> $fn
          '';
        in lib.concatMapStrings f events
      }
    '';

  events = [powerEvent lidEvent acEvent];

  # Called when the power button is pressed.
  powerEvent =
    { name = "power-button";
      event = "button/power.*";
      action =
        ''
          #! ${pkgs.bash}/bin/sh
          ${config.services.acpid.powerEventCommands}
        '';
    };

  # Called when the laptop lid is opened/closed.
  lidEvent =
    { name = "lid";
      event = "button/lid.*";
      action =
        ''
          #! ${pkgs.bash}/bin/sh
          ${config.services.acpid.lidEventCommands}
        '';
    };

  # Called when the AC power is connected or disconnected.
  acEvent =
    { name = "ac-power";
      event = "ac_adapter.*";
      action =
        ''
          #! ${pkgs.bash}/bin/sh
          ${config.services.acpid.acEventCommands}
        '';
    };

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
