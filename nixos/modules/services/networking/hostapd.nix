{ config, lib, pkgs, utils, ... }:

# TODO:
#
# asserts
#   ensure that the nl80211 module is loaded/compiled in the kernel
#   wpa_supplicant and hostapd on the same wireless interface doesn't make any sense

with lib;

let

  cfg = config.services.hostapd;

  escapedInterface = utils.escapeSystemdPath cfg.interface;

  configFile = pkgs.writeText "hostapd.conf" ''
    interface=${cfg.interface}
    driver=${cfg.driver}
    ssid=${cfg.ssid}
    hw_mode=${cfg.hwMode}
    channel=${toString cfg.channel}

    # logging (debug level)
    logger_syslog=-1
    logger_syslog_level=2
    logger_stdout=-1
    logger_stdout_level=2

    ctrl_interface=/run/hostapd
    ctrl_interface_group=${cfg.group}

    ${optionalString cfg.wpa ''
      wpa=2
      wpa_passphrase=${cfg.wpaPassphrase}
    ''}
    ${optionalString cfg.noScan "noscan=1"}

    ${cfg.extraConfig}
  '' ;

in

{
  ###### interface

  options = {

    services.hostapd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable putting a wireless interface into infrastructure mode,
          allowing other wireless devices to associate with the wireless
          interface and do wireless networking. A simple access point will
          <option>enable hostapd.wpa</option>,
          <option>hostapd.wpaPassphrase</option>, and
          <option>hostapd.ssid</option>, as well as DHCP on the wireless
          interface to provide IP addresses to the associated stations, and
          NAT (from the wireless interface to an upstream interface).
        '';
      };

      interface = mkOption {
        default = "";
        example = "wlp2s0";
        description = ''
          The interfaces <command>hostapd</command> will use.
        '';
      };

      noScan = mkOption {
        default = false;
        description = ''
          Do not scan for overlapping BSSs in HT40+/- mode.
          Caution: turning this on will violate regulatory requirements!
        '';
      };

      driver = mkOption {
        default = "nl80211";
        example = "hostapd";
        type = types.str;
        description = ''
          Which driver <command>hostapd</command> will use.
          Most applications will probably use the default.
        '';
      };

      ssid = mkOption {
        default = "nixos";
        example = "mySpecialSSID";
        type = types.str;
        description = "SSID to be used in IEEE 802.11 management frames.";
      };

      hwMode = mkOption {
        default = "g";
        type = types.enum [ "a" "b" "g" ];
        description = ''
          Operation mode.
          (a = IEEE 802.11a, b = IEEE 802.11b, g = IEEE 802.11g).
        '';
      };

      channel = mkOption {
        default = 7;
        example = 11;
        type = types.int;
        description = ''
          Channel number (IEEE 802.11)
          Please note that some drivers do not use this value from
          <command>hostapd</command> and the channel will need to be configured
          separately with <command>iwconfig</command>.
        '';
      };

      group = mkOption {
        default = "wheel";
        example = "network";
        type = types.str;
        description = ''
          Members of this group can control <command>hostapd</command>.
        '';
      };

      wpa = mkOption {
        default = true;
        description = ''
          Enable WPA (IEEE 802.11i/D3.0) to authenticate with the access point.
        '';
      };

      wpaPassphrase = mkOption {
        default = "my_sekret";
        example = "any_64_char_string";
        type = types.str;
        description = ''
          WPA-PSK (pre-shared-key) passphrase. Clients will need this
          passphrase to associate with this access point.
          Warning: This passphrase will get put into a world-readable file in
          the Nix store!
        '';
      };

      extraConfig = mkOption {
        default = "";
        example = ''
          auth_algo=0
          ieee80211n=1
          ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]
          '';
        type = types.lines;
        description = "Extra configuration options to put in hostapd.conf.";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages =  [ pkgs.hostapd ];

    systemd.services.hostapd =
      { description = "hostapd wireless AP";

        path = [ pkgs.hostapd ];
        after = [ "sys-subsystem-net-devices-${escapedInterface}.device" ];
        bindsTo = [ "sys-subsystem-net-devices-${escapedInterface}.device" ];
        requiredBy = [ "network-link-${cfg.interface}.service" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig =
          { ExecStart = "${pkgs.hostapd}/bin/hostapd ${configFile}";
            Restart = "always";
          };
      };
  };
}
