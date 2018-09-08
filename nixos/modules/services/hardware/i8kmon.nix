{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.i8kmon;

in {

  options = {

    services.i8kmon = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable i8kmon, fan controller for Dell laptops.
          *ATTENTION* Use at your own risk, as misconfiguration can lead to hardware damage.
        '';
      };

      state0 = mkOption {
        type = types.str;
        default = "{0 0} \-1 60 \-1 65";
        description = ''
          {LEFTFANSTATE RIGHTFANSTATE} LOWONAC HIGHONAC LOWONBATTERY HIGHONBATTERY
          LEFTFANSTATE 0 disabled, 1 enabled, - fan missing
          RIGHTFANSTATE 0 disabled, 1 enabled, - fan missing
	  LOWON{AC,BATTERY} low threshold on state 0, must be '\-1'.
          HIGHON{AC,BATTERY} maximum threshold on state 0.
          Read the i8kmon manpage for more information about these values.
        '';
      };

      state1 = mkOption {
        type = types.str;
        default = "{1 0} 50 70 55 75";
        description = ''
          {LEFTFANSTATE RIGHTFANSTATE} LOWONAC HIGHONAC LOWONBATTERY HIGHONBATTERY
          LEFTFANSTATE 0 disabled, 1 enabled, - fan missing
          RIGHTFANSTATE 0 disabled, 1 enabled, - fan missing
	  LOWON{AC,BATTERY} low threshold on state 1.
          HIGHON{AC,BATTERY} maximum threshold on state 1.
          Read the i8kmon manpage for more information about these values.
        '';
      };

      state2 = mkOption {
        type = types.str;
        default = "{1 1} 60 80 65 85";
        description = ''
          {LEFTFANSTATE RIGHTFANSTATE} LOWONAC HIGHONAC LOWONBATTERY HIGHONBATTERY
          LEFTFANSTATE 0 disabled, 1 enabled, - fan missing
          RIGHTFANSTATE 0 disabled, 1 enabled, - fan missing
	  LOWON{AC,BATTERY} low threshold on state 2.
          HIGHON{AC,BATTERY} maximum threshold on state 2.
          Read the i8kmon manpage for more information about these values.
        '';
      };

      state3 = mkOption {
        type = types.str;
        default = "{2 2} 70 128 75 128";
        description = ''
          {LEFTFANSTATE RIGHTFANSTATE} LOWONAC HIGHONAC LOWONBATTERY HIGHONBATTERY
          LEFTFANSTATE 0 disabled, 1 enabled, - fan missing
          RIGHTFANSTATE 0 disabled, 1 enabled, - fan missing
	  LOWON{AC,BATTERY} low threshold on state 3.
          HIGHON{AC,BATTERY} maximum threshold on state 3, must be '128'.
          Read the i8kmon manpage for more information about these values.
        '';
      };

      leftspeed = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          STATE0SPEED STATE1SPEED STATE2SPEED STATE3SPEED
          Speed values of the left fan at the states 0 - 3.
          Example: '0 1000 2000 3000'
          If the values are not given, i8kmon will probe these values (turns fan on at maximum).
        '';
      };

      rightspeed = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          STATE0SPEED STATE1SPEED STATE2SPEED STATE3SPEED
          Speed values of the right fan at the states 0 - 3.
          Example: '0 1000 2000 3000'
          If the values are not given, i8kmon will probe these values (turns fan on at maximum).
        '';
      };

    };

  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.dell-bios-fan-control pkgs.i8kutils ];

    environment.etc = {
      "i8kmon.conf" = {
        source = pkgs.writeText "i8kmon.conf" ''
          set config(0) {${cfg.state0}}
          set config(1) {${cfg.state1}}
          set config(2) {${cfg.state2}}
          set config(3) {${cfg.state3}}

          ${lib.optionalString (cfg.leftspeed != null) ''set status(leftspeed) "${cfg.leftspeed}"''}
          ${lib.optionalString (cfg.rightspeed != null) ''set status(rightspeed) "${cfg.rightspeed}"''}
        '';
      };
    };

    systemd.services.i8kmon = {
      description = "i8kmon";
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        ConditionPathExists = [ "/proc/i8k" ];
      };
      serviceConfig = {
        ExecStartPre = "${pkgs.dell-bios-fan-control}/bin/dell-bios-fan-control 0";
        ExecStopPost = "${pkgs.dell-bios-fan-control}/bin/dell-bios-fan-control 1";
        ExecStart = "${pkgs.i8kutils}/bin/i8kmon -nc";
        Restart = "always";
        RestartSec = 5;
      };
    };

  };

}
