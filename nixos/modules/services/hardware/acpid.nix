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

  events = [powerEvent lidEvent acEvent muteEvent volumeDownEvent volumeUpEvent cdPlayEvent cdNextEvent cdPrevEvent];

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

  muteEvent = {
    name = "mute";
    event = "button/mute.*";
    action = ''
      #! ${pkgs.bash}/bin/sh
      ${config.services.acpid.muteCommands}
    '';
  };

  volumeDownEvent = {
    name = "volume-down";
    event = "button/volumedown.*";
    action = ''
      #! ${pkgs.bash}/bin/sh
      ${config.services.acpid.volumeDownEventCommands}
    '';
  };

  volumeUpEvent = {
    name = "volume-up";
    event = "button/volumeup.*";
    action = ''
      #! ${pkgs.bash}/bin/sh
      ${config.services.acpid.volumeUpEventCommands}
    '';
  };

  cdPlayEvent = {
    name = "cd-play";
    event = "cd/play.*";
    action = ''
      #! ${pkgs.bash}/bin/sh
      ${config.services.acpid.cdPlayEventCommands}
    '';
  };

  cdNextEvent = {
    name = "cd-next";
    event = "cd/next.*";
    action = ''
      #! ${pkgs.bash}/bin/sh
      ${config.services.acpid.cdNextEventCommands}
    '';
  };

  cdPrevEvent = {
    name = "cd-prev";
    event = "cd/prev.*";
    action = ''
      #! ${pkgs.bash}/bin/sh
      ${config.services.acpid.cdPrevEventCommands}
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

      muteCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to execute on an button/mute.* event.";
      };

      volumeDownEventCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to execute on an button/volumedown.* event.";
      };

      volumeUpEventCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to execute on an button/volumeup.* event.";
      };

      cdPlayEventCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to execute on an cd/play.* event.";
      };

      cdNextEventCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to execute on an cd/next.* event.";
      };

      cdPrevEventCommands = mkOption {
        type = types.lines;
        default = "";
        description = "Shell commands to execute on an cd/prev.* event.";
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
