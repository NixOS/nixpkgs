{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.hardware.logitech;

  vendor = "046d";

  daemon = "g15daemon";

in
{
  imports = [
    (mkRenamedOptionModule [ "hardware" "logitech" "enable" ] [ "hardware" "logitech" "wireless" "enable" ])
    (mkRenamedOptionModule [ "hardware" "logitech" "enableGraphical" ] [ "hardware" "logitech" "wireless" "enableGraphical" ])
  ];

  options.hardware.logitech = {

    lcd = {
      enable = mkEnableOption "support for Logitech LCD Devices";

      startWhenNeeded = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Only run the service when an actual supported device is plugged.
        '';
      };

      devices = mkOption {
        type = types.listOf types.str;
        default = [ "0a07" "c222" "c225" "c227" "c251" ];
        description = ''
          List of USB device ids supported by g15daemon.

          You most likely do not need to change this.
        '';
      };
    };

    wireless = {
      enable = mkEnableOption "support for Logitech Wireless Devices";

      enableGraphical = mkOption {
        type = types.bool;
        default = false;
        description = "Enable graphical support applications.";
      };
    };
  };

  config = lib.mkIf (cfg.wireless.enable || cfg.lcd.enable) {
    environment.systemPackages = []
      ++ lib.optional cfg.wireless.enable pkgs.ltunify
      ++ lib.optional cfg.wireless.enableGraphical pkgs.solaar;

    services.udev = {
      # ltunifi and solaar both provide udev rules but the most up-to-date have been split
      # out into a dedicated derivation

      packages = []
      ++ lib.optional cfg.wireless.enable pkgs.logitech-udev-rules
      ++ lib.optional cfg.lcd.enable pkgs.g15daemon;

      extraRules = ''
        # nixos: hardware.logitech.lcd
      '' + lib.concatMapStringsSep "\n" (
        dev:
          ''ACTION=="add", SUBSYSTEMS=="usb", ATTRS{idVendor}=="${vendor}", ATTRS{idProduct}=="${dev}", TAG+="systemd", ENV{SYSTEMD_WANTS}+="${daemon}.service"''
      ) cfg.lcd.devices;
    };

    systemd.services."${daemon}" = lib.mkIf cfg.lcd.enable {
      description = "Logitech LCD Support Daemon";
      documentation = [ "man:g15daemon(1)" ];
      wantedBy = lib.mkIf (! cfg.lcd.startWhenNeeded) "multi-user.target";

      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.g15daemon}/bin/g15daemon";
        # we patch it to write to /run/g15daemon/g15daemon.pid instead of
        # /run/g15daemon.pid so systemd will do the cleanup for us.
        PIDFile = "/run/${daemon}/g15daemon.pid";
        PrivateTmp = true;
        PrivateNetwork = true;
        ProtectHome = "tmpfs";
        ProtectSystem = "full"; # strict doesn't work
        RuntimeDirectory = daemon;
        Restart = "on-failure";
      };
    };
  };
}
