{ config, pkgs, ... }:

with pkgs.lib;

let

  configFile = "/etc/wpa_supplicant.conf";

  ifaces =
    config.networking.wireless.interfaces ++
    optional (config.networking.WLANInterface != "") config.networking.WLANInterface;

in

{

  ###### interface

  options = {
  
    networking.wireless.enable = mkOption {
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

    networking.WLANInterface = mkOption {
      default = "";
      description = "Obsolete. Use <option>networking.wireless.interfaces</option> instead.";
    };

    networking.wireless.interfaces = mkOption {
      default = [];
      example = [ "wlan0" "wlan1" ];
      description = ''
        The interfaces <command>wpa_supplicant</command> will use.  If empty, it will
        automatically use all wireless interfaces.
      '';
    };

  };


  ###### implementation
  
  config = mkIf config.networking.wireless.enable {

    environment.systemPackages =  [ pkgs.wpa_supplicant ];

    services.dbus.packages = [ pkgs.wpa_supplicant ];

    jobs.wpa_supplicant = 
      { startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

        path = [ pkgs.wpa_supplicant ];

        preStart =
          ''
            touch -a ${configFile}
            chmod 600 ${configFile}
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
            exec wpa_supplicant -s -u -c ${configFile} $ifaces
          '';
      };
  
    powerManagement.resumeCommands =
      ''
        ${config.system.build.upstart}/sbin/restart wpa_supplicant
      '';

  };

}
