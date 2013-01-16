{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.smartd;

  smartdMail = pkgs.writeScript "smartdmail.sh" ''
    #! ${pkgs.stdenv.shell}
    TMPNAM=/tmp/smartd-message.$$.tmp
    if test -n "$SMARTD_ADDRESS"; then
      echo  >"$TMPNAM" "From: smartd <root>"
      echo >>"$TMPNAM" 'To: undisclosed-recipients:;'
      echo >>"$TMPNAM" "Subject: $SMARTD_SUBJECT"
      echo >>"$TMPNAM"
      echo >>"$TMPNAM" "Failure on $SMARTD_DEVICESTRING: $SMARTD_FAILTYPE"
      echo >>"$TMPNAM"
      cat  >>"$TMPNAM"
      ${pkgs.smartmontools}/sbin/smartctl >>"$TMPNAM" -a -d "$SMARTD_DEVICETYPE" "$SMARTD_DEVICE"
      /var/setuid-wrappers/sendmail  <"$TMPNAM" -f "$SENDER" -i "$SMARTD_ADDRESS"
    fi
  '';

  smartdConf = pkgs.writeText "smartd.conf" (concatMapStrings (device:
    ''
      ${device} -a -m root -M exec ${smartdMail} ${cfg.deviceOpts}
    ''
    ) cfg.devices);

  smartdFlags = if (cfg.devices == []) then "" else "--configfile=${smartdConf}";

in

{
  ###### interface

  options = {

    services.smartd = {

      enable = mkOption {
        default = false;
        type = types.bool;
        example = "true";
        description = ''
          Run smartd from the smartmontools package. Note that e-mail
          notifications will not be enabled unless you configure the list of
          devices with <varname>services.smartd.devices</varname> as well.
        '';
      };

      deviceOpts = mkOption {
        default = "";
        type = types.string;
        example = "-o on -s (S/../.././02|L/../../7/04)";
        description = ''
          Additional options for each device that is monitored. The example
          turns on SMART Automatic Offline Testing on startup, and schedules short
          self-tests daily, and long self-tests weekly.
        '';
      };

      devices = mkOption {
        default = [];
        example = ["/dev/sda" "/dev/sdb"];
        description = ''
          List of devices to monitor. By default -- if this list is empty --,
          smartd will monitor all devices connected to the machine at the time
          it's being run. Configuring this option has the added benefit of
          enabling e-mail notifications to "root" every time smartd detects an
          error.
        '';
       };
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.smartd = {
      description = "S.M.A.R.T. Daemon";

      environment.TZ = config.time.timeZone;

      wantedBy = [ "multi-user.target" ];

      serviceConfig.ExecStart = "${pkgs.smartmontools}/sbin/smartd --no-fork ${smartdFlags}";
    };

  };

}
