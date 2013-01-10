{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.networking.wireless;
  configFile = "/etc/wpa_supplicant.conf";

  ifaces =
    cfg.interfaces ++
    optional (config.networking.WLANInterface != "") config.networking.WLANInterface;

in

{

  ###### interface

  options = {

    networking.WLANInterface = mkOption {
      default = "";
      description = "Obsolete. Use <option>networking.wireless.interfaces</option> instead.";
    };

    networking.wireless = {
      enable = mkOption {
        default = false;
        description = ''
          Whether to start <command>wpa_supplicant</command> to scan for
          and associate with wireless networks.  Note: NixOS currently
          does not generate <command>wpa_supplicant</command>'s
          configuration file, <filename>${configFile}</filename>.  You
          should edit this file yourself to define wireless networks,
          WPA keys and so on (see
          <citerefentry><refentrytitle>wpa_supplicant.conf</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry>).
        '';
      };

      interfaces = mkOption {
        default = [];
        example = [ "wlan0" "wlan1" ];
        description = ''
          The interfaces <command>wpa_supplicant</command> will use.  If empty, it will
          automatically use all wireless interfaces. (Note that auto-detection is currently
          broken on Linux 3.4.x kernels. See http://github.com/NixOS/nixos/issues/10 for
          further details.)
        '';
      };

      driver = mkOption {
        default = "";
        example = "nl80211";
        description = "Force a specific wpa_supplicant driver.";
      };

      userControlled = {
        enable = mkOption {
          default = false;
          description = ''
            Allow normal users to control wpa_supplicant through wpa_gui or wpa_cli.
            This is useful for laptop users that switch networks a lot.

            When you want to use this, make sure ${configFile} doesn't exist.
            It will be created for you.

            Currently it is also necessary to explicitly specify networking.wireless.interfaces.
          '';
        };

        group = mkOption {
          default = "wheel";
          example = "network";
          type = types.string;
          description = "Members of this group can control wpa_supplicant.";
        };
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages =  [ pkgs.wpa_supplicant ];

    services.dbus.packages = [ pkgs.wpa_supplicant ];

    jobs.wpa_supplicant =
      { description = "WPA Supplicant";

        wantedBy = [ "network.target" ];
        after = [ "systemd-udev-settle.service" ];

        path = [ pkgs.wpa_supplicant ];

        preStart = ''
          touch -a ${configFile}
          chmod 600 ${configFile}
        '' + optionalString cfg.userControlled.enable ''
          if [ ! -s ${configFile} ]; then
            echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=${cfg.userControlled.group}" >> ${configFile}
            echo "update_config=1" >> ${configFile}
          fi
        '';

        script =
          ''
            ${if ifaces == [] then ''
              for i in $(cd /sys/class/net && echo *); do
                if [ -e /sys/class/net/$i/wireless ]; then
                  ifaces="$ifaces''${ifaces:+ -N} -i$i"
                fi
              done
            '' else ''
              ifaces="${concatStringsSep " -N " (map (i: "-i${i}") ifaces)}"
            ''}
            exec wpa_supplicant -s -u ${optionalString (cfg.driver != "") "-D${cfg.driver}"} -c ${configFile} $ifaces
          '';
      };

    powerManagement.resumeCommands =
      ''
        ${config.system.build.systemd}/bin/systemctl try-restart wpa_supplicant
      '';

    assertions = [{ assertion = !cfg.userControlled.enable || cfg.interfaces != [];
                    message = "user controlled wpa_supplicant needs explicit networking.wireless.interfaces";}];

  };

}
