{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  cfg = config.networking.networkmanager;

  # /var/lib/misc is for dnsmasq.leases.
  stateDirs = "/var/lib/NetworkManager /var/lib/dhclient /var/lib/misc";

  configFile = writeText "NetworkManager.conf" ''
    [main]
    plugins=keyfile

    [keyfile]
    ${optionalString (config.networking.hostName != "")
      ''hostname=${config.networking.hostName}''}
    ${optionalString (cfg.unmanaged != [])
      ''unmanaged-devices=${lib.concatStringsSep ";" cfg.unmanaged}''}

    [logging]
    level=WARN

    [connection]
    ipv6.ip6-privacy=2
  '';

  /*
    [network-manager]
    Identity=unix-group:networkmanager
    Action=org.freedesktop.NetworkManager.*
    ResultAny=yes
    ResultInactive=no
    ResultActive=yes

    [modem-manager]
    Identity=unix-group:networkmanager
    Action=org.freedesktop.ModemManager*
    ResultAny=yes
    ResultInactive=no
    ResultActive=yes
  */
  polkitConf = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("networkmanager")
        && (action.id.indexOf("org.freedesktop.NetworkManager.") == 0
            || action.id.indexOf("org.freedesktop.ModemManager")  == 0
        ))
          { return polkit.Result.YES; }
    });
  '';

  ns = xs: writeText "nameservers" (
    concatStrings (map (s: "nameserver ${s}\n") xs)
  );

  overrideNameserversScript = writeScript "02overridedns" ''
    #!/bin/sh
    tmp=`${coreutils}/bin/mktemp`
    ${gnused}/bin/sed '/nameserver /d' /etc/resolv.conf > $tmp
    ${gnugrep}/bin/grep 'nameserver ' /etc/resolv.conf | \
      ${gnugrep}/bin/grep -vf ${ns (cfg.appendNameservers ++ cfg.insertNameservers)} > $tmp.ns
    ${optionalString (cfg.appendNameservers != []) "${coreutils}/bin/cat $tmp $tmp.ns ${ns cfg.appendNameservers} > /etc/resolv.conf"}
    ${optionalString (cfg.insertNameservers != []) "${coreutils}/bin/cat $tmp ${ns cfg.insertNameservers} $tmp.ns > /etc/resolv.conf"}
    ${coreutils}/bin/rm -f $tmp $tmp.ns
  '';

  dispatcherTypesSubdirMap = {
    "basic" = "";
    "pre-up" = "pre-up.d/";
    "pre-down" = "pre-down.d/";
  };

in {

  ###### interface

  options = {

    networking.networkmanager = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use NetworkManager to obtain an IP address and other
          configuration for all network interfaces that are not manually
          configured. If enabled, a group <literal>networkmanager</literal>
          will be created. Add all users that should have permission
          to change network settings to this group.
        '';
      };

      unmanaged = mkOption {
        type = types.listOf types.string;
        default = [];
        description = ''
          List of interfaces that will not be managed by NetworkManager.
          Interface name can be specified here, but if you need more fidelity
          see "Device List Format" in NetworkManager.conf man page.
        '';
      };

      # Ugly hack for using the correct gnome3 packageSet
      basePackages = mkOption {
        type = types.attrsOf types.package;
        default = { inherit networkmanager modemmanager wpa_supplicant
                            networkmanager_openvpn networkmanager_vpnc
                            networkmanager_openconnect
                            networkmanager_pptp networkmanager_l2tp; };
        internal = true;
      };

      packages = mkOption {
        type = types.listOf types.path;
        default = [ ];
        description = ''
          Extra packages that provide NetworkManager plugins.
        '';
        apply = list: (attrValues cfg.basePackages) ++ list;
      };

      appendNameservers = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          A list of name servers that should be appended
          to the ones configured in NetworkManager or received by DHCP.
        '';
      };

      insertNameservers = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          A list of name servers that should be inserted before
          the ones configured in NetworkManager or received by DHCP.
        '';
      };

      dispatcherScripts = mkOption {
        type = types.listOf (types.submodule {
          options = {
            source = mkOption {
              type = types.str;
              description = ''
                A script source.
              '';
            };

            type = mkOption {
              type = types.enum (attrNames dispatcherTypesSubdirMap); 
              default = "basic";
              description = ''
                Dispatcher hook type. Only basic hooks are currently available.
              '';
            };
          };
        });
        default = [];
        description = ''
          A list of scripts which will be executed in response to  network  events.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [{
      assertion = config.networking.wireless.enable == false;
      message = "You can not use networking.networkmanager with services.networking.wireless";
    }];

    boot.kernelModules = [ "ppp_mppe" ]; # Needed for most (all?) PPTP VPN connections.

    environment.etc = with cfg.basePackages; [
      { source = configFile;
        target = "NetworkManager/NetworkManager.conf";
      }
      { source = "${networkmanager_openvpn}/etc/NetworkManager/VPN/nm-openvpn-service.name";
        target = "NetworkManager/VPN/nm-openvpn-service.name";
      }
      { source = "${networkmanager_vpnc}/etc/NetworkManager/VPN/nm-vpnc-service.name";
        target = "NetworkManager/VPN/nm-vpnc-service.name";
      }
      { source = "${networkmanager_openconnect}/etc/NetworkManager/VPN/nm-openconnect-service.name";
        target = "NetworkManager/VPN/nm-openconnect-service.name";
      }
      { source = "${networkmanager_pptp}/etc/NetworkManager/VPN/nm-pptp-service.name";
        target = "NetworkManager/VPN/nm-pptp-service.name";
      }
      { source = "${networkmanager_l2tp}/etc/NetworkManager/VPN/nm-l2tp-service.name";
        target = "NetworkManager/VPN/nm-l2tp-service.name";
      }
    ] ++ optional (cfg.appendNameservers == [] || cfg.insertNameservers == [])
           { source = overrideNameserversScript;
             target = "NetworkManager/dispatcher.d/02overridedns";
           }
      ++ lib.imap (i: s: {
        text = s.source;
        target = "NetworkManager/dispatcher.d/${dispatcherTypesSubdirMap.${s.type}}03userscript${lib.fixedWidthNumber 4 i}";
      }) cfg.dispatcherScripts;

    environment.systemPackages = cfg.packages;

    users.extraGroups = [{
      name = "networkmanager";
      gid = config.ids.gids.networkmanager;
    }
    {
      name = "nm-openvpn";
      gid = config.ids.gids.nm-openvpn;
    }];
    users.extraUsers = [{
      name = "nm-openvpn";
      uid = config.ids.uids.nm-openvpn;
    }];

    systemd.packages = cfg.packages;

    systemd.services."network-manager" = {
      wantedBy = [ "network.target" ];

      preStart = ''
        mkdir -m 700 -p /etc/NetworkManager/system-connections
        mkdir -m 755 -p ${stateDirs}
      '';
    };

    # Turn off NixOS' network management
    networking = {
      useDHCP = false;
      wireless.enable = false;
    };

    powerManagement.resumeCommands = ''
      ${config.systemd.package}/bin/systemctl restart network-manager
    '';

    security.polkit.extraConfig = polkitConf;

    services.dbus.packages = cfg.packages;

    services.udev.packages = cfg.packages;
  };
}
