{ config, pkgs, ... }:

# TODO:
#
# asserts 
#   ensure that the nl80211 module is loaded/compiled in the kernel
#   hwMode must be a/b/g
#   channel must be between 1 and 13 (maybe)
#   wpa_supplicant and hostapd on the same wireless interface doesn't make any sense
#   perhaps an assertion that there is a dhcp server and a dns server on the IP address serviced by the hostapd?

with pkgs.lib;

let

  cfg = config.services.hostapd;
  
  configFile = pkgs.writeText "hostapd.conf"  
    ''
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

    ctrl_interface=/var/run/hostapd
    ctrl_interface_group=${cfg.group}

    ${if cfg.wpa then ''
      wpa=1
      wpa_passphrase=${cfg.wpaPassphrase}
      '' else ""}

    ${cfg.extraCfg}
    '' ;

in

{
  ###### interface

  options = {

    services.hostapd = {

      enable = mkOption {
        default = false;
        description = ''
          Enable putting a wireless interface into infrastructure mode,
          allowing other wireless devices to associate with the wireless interface and do
          wireless networking. A simple access point will enable hostapd.wpa, and
          hostapd.wpa_passphrase, hostapd.ssid, dhcpd on the wireless interface to
          provide IP addresses to the associated stations, and nat (from the wireless
          interface to an upstream interface). 
        '';
      };

      interface = mkOption {
        default = "";
        example = "wlan0";
        description = ''
          The interfaces <command>hostapd</command> will use. 
        '';
      };

      driver = mkOption {
        default = "nl80211";
        example = "hostapd";
        type = types.string;
        description = "Which driver hostapd will use. Most things will probably use the default.";
      };

      ssid = mkOption {
        default = "nixos";
        example = "mySpecialSSID";
        type = types.string;
        description = "SSID to be used in IEEE 802.11 management frames.";
      };

      hwMode = mkOption {
        default = "b";
        example = "g";
        type = types.string;
        description = "Operation mode (a = IEEE 802.11a, b = IEEE 802.11b, g = IEEE 802.11g";
      };

      channel = mkOption { 
        default = 7;
        example = 11;
        type = types.int;
        description = 
          ''
          Channel number (IEEE 802.11)
          Please note that some drivers do not use this value from hostapd and the
          channel will need to be configured separately with iwconfig.
          '';
      };

      group = mkOption {
        default = "wheel";
        example = "network";
        type = types.string;
        description = "members of this group can control hostapd";
      };

      wpa = mkOption {
        default = true;
        description = "enable WPA (IEEE 802.11i/D3.0) to authenticate to the access point";
      };

      wpaPassphrase = mkOption {
        default = "my_sekret";
        example = "any_64_char_string";
        type = types.string;
        description = 
          ''
          WPA-PSK (pre-shared-key) passphrase. Clients will need this
          passphrase to associate with this access point. Warning: This passphrase will
          get put into a world-readable file in the nix store. 
          '';
      };

      extraCfg = mkOption {
        default = "";
        example = ''
          auth_algo=0
          ieee80211n=1
          ht_capab=[HT40-][SHORT-GI-40][DSSS_CCK-40]
          '';
        type = types.string;
        description = "Extra configuration options to put in the hostapd.conf";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages =  [ pkgs.hostapd ];

    systemd.services.hostapd =
      { description = "hostapd wireless AP";

        path = [ pkgs.hostapd ]; 

        after = [ "${cfg.interface}-cfg.service" "nat.service" "bind.service" "dhcpd.service"];

        serviceConfig = 
          { ExecStart = "${pkgs.hostapd}/bin/hostapd ${configFile}";
            Restart = "always";
          };
      };
  };
}
