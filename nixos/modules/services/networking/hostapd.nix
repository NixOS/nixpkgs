{ config, lib, pkgs, utils, ... }:

# TODO:
#
# asserts
#   ensure interface name is set
#   ensure that the nl80211 module is loaded/compiled in the kernel
#   wpa_supplicant and hostapd on the same wireless interface doesn't make any sense

with lib;

let

  cfg = config.services.hostapd;

  generateConfigFile = AP: pkgs.writeText "hostapd-${AP.interface}.conf" ''
    interface=${AP.interface}
    driver=${AP.driver}
    ssid=${AP.ssid}
    hw_mode=${AP.hwMode}
    channel=${toString AP.channel}

    # logging (debug level)
    logger_syslog=-1
    logger_syslog_level=2
    logger_stdout=-1
    logger_stdout_level=2

    ctrl_interface=/run/hostapd
    ctrl_interface_group=${AP.group}

    ${optionalString AP.wpa ''
      wpa=2
      wpa_passphrase=${AP.wpaPassphrase}
    ''}

    ${optionalString AP.noScan "noscan=1"}

    ${AP.extraConfig}
  '' ;

  generateUnit = AP: let
    escapedInterfaceName = utils.escapeSystemdPath AP.interface;
  in nameValuePair "hostapd-${escapedInterfaceName}" {
    description = "hostapd wireless AP on ${AP.interface}";

    path = [ pkgs.hostapd ];

    after = [ "sys-subsystem-net-devices-${escapedInterfaceName}.device" "${escapedInterfaceName}-cfg.service" "network.target" ];
    bindsTo = [ "sys-subsystem-net-devices-${escapedInterfaceName}.device" ];

    serviceConfig = {
      ExecStart = "${pkgs.hostapd}/bin/hostapd ${generateConfigFile AP}";
      Restart = "always";
    };
  };


in

{
  ###### interface

  options = {

    services.hostapd = {

      enable = mkOption {
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

      APs = mkOption {
        default = [];
        description = ''
          A list of complete hostapd configurations (one per network interface/AP
          you want to run).
        '';

        type = with types; listOf (submodule {

          options = {

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

            bridge = mkOption {
              default = null;
              type = types.nullOr types.str;
              example = "br0";
              description = ''
                The (optional) name of the bridge to add this AP to.
              '';
            };

            driver = mkOption {
              default = "nl80211";
              example = "hostapd";
              type = types.string;
              description = ''
                Which driver <command>hostapd</command> will use.
                Most applications will probably use the default.
              '';
            };

            ssid = mkOption {
              default = "nixos";
              example = "mySpecialSSID";
              type = types.string;
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
              type = types.string;
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
              type = types.string;
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
        });
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages =  [ pkgs.hostapd ];

    systemd.services = listToAttrs (map generateUnit cfg.APs);
  };
}
