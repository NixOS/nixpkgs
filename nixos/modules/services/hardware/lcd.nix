{ config, lib, pkgs, ... }:

let
  cfg = config.services.hardware.lcd;
  pkg = lib.getBin pkgs.lcdproc;

  serverCfg = pkgs.writeText "lcdd.conf" ''
    [server]
    DriverPath=${pkg}/lib/lcdproc/
    ReportToSyslog=false
    Bind=${cfg.serverHost}
    Port=${toString cfg.serverPort}
    ${cfg.server.extraConfig}
  '';

  clientCfg = pkgs.writeText "lcdproc.conf" ''
    [lcdproc]
    Server=${cfg.serverHost}
    Port=${toString cfg.serverPort}
    ReportToSyslog=false
    ${cfg.client.extraConfig}
  '';

  serviceCfg = {
    DynamicUser = true;
    Restart = "on-failure";
    Slice = "lcd.slice";
  };

in with lib; {

  meta.maintainers = with maintainers; [ peterhoeg ];

  options = with types; {
    services.hardware.lcd = {
      serverHost = mkOption {
        type = str;
        default = "localhost";
        description = lib.mdDoc "Host on which LCDd is listening.";
      };

      serverPort = mkOption {
        type = int;
        default = 13666;
        description = lib.mdDoc "Port on which LCDd is listening.";
      };

      server = {
        enable = mkOption {
          type = bool;
          default = false;
          description = lib.mdDoc "Enable the LCD panel server (LCDd)";
        };

        openPorts = mkOption {
          type = bool;
          default = false;
          description = lib.mdDoc "Open the ports in the firewall";
        };

        usbPermissions = mkOption {
          type = bool;
          default = false;
          description = ''
            Set group-write permissions on a USB device.

            A USB connected LCD panel will most likely require having its
            permissions modified for lcdd to write to it. Enabling this option
            sets group-write permissions on the device identified by
            <option>services.hardware.lcd.usbVid</option> and
            <option>services.hardware.lcd.usbPid</option>. In order to find the
            values, you can run the <command>lsusb</command> command. Example
            output:

            <literal>
            Bus 005 Device 002: ID 0403:c630 Future Technology Devices International, Ltd lcd2usb interface
            </literal>

            In this case the vendor id is 0403 and the product id is c630.
          '';
        };

        usbVid = mkOption {
          type = str;
          default = "";
          description = lib.mdDoc "The vendor ID of the USB device to claim.";
        };

        usbPid = mkOption {
          type = str;
          default = "";
          description = lib.mdDoc "The product ID of the USB device to claim.";
        };

        usbGroup = mkOption {
          type = str;
          default = "dialout";
          description = lib.mdDoc "The group to use for settings permissions. This group must exist or you will have to create it.";
        };

        extraConfig = mkOption {
          type = lines;
          default = "";
          description = lib.mdDoc "Additional configuration added verbatim to the server config.";
        };
      };

      client = {
        enable = mkOption {
          type = bool;
          default = false;
          description = lib.mdDoc "Enable the LCD panel client (LCDproc)";
        };

        extraConfig = mkOption {
          type = lines;
          default = "";
          description = lib.mdDoc "Additional configuration added verbatim to the client config.";
        };

        restartForever = mkOption {
          type = bool;
          default = true;
          description = lib.mdDoc "Try restarting the client forever.";
        };
      };
    };
  };

  config = mkIf (cfg.server.enable || cfg.client.enable) {
    networking.firewall.allowedTCPPorts = mkIf (cfg.server.enable && cfg.server.openPorts) [ cfg.serverPort ];

    services.udev.extraRules = mkIf (cfg.server.enable && cfg.server.usbPermissions) ''
      ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="${cfg.server.usbVid}", ATTRS{idProduct}=="${cfg.server.usbPid}", MODE="660", GROUP="${cfg.server.usbGroup}"
    '';

    systemd.services = {
      lcdd = mkIf cfg.server.enable {
        description = "LCDproc - server";
        wantedBy = [ "lcd.target" ];
        serviceConfig = serviceCfg // {
          ExecStart = "${pkg}/bin/LCDd -f -c ${serverCfg}";
          SupplementaryGroups = cfg.server.usbGroup;
        };
      };

      lcdproc = mkIf cfg.client.enable {
        description = "LCDproc - client";
        after = [ "lcdd.service" ];
        wantedBy = [ "lcd.target" ];
        # Allow restarting for eternity
        startLimitIntervalSec = lib.mkIf cfg.client.restartForever 0;
        serviceConfig = serviceCfg // {
          ExecStart = "${pkg}/bin/lcdproc -f -c ${clientCfg}";
          # If the server is being restarted at the same time, the client will
          # fail as it cannot connect, so space it out a bit.
          RestartSec = "5";
        };
      };
    };

    systemd.targets.lcd = {
      description = "LCD client/server";
      after = [ "lcdd.service" "lcdproc.service" ];
      wantedBy = [ "multi-user.target" ];
    };
  };
}
