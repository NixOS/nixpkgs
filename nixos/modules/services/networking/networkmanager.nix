{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  cfg = config.networking.networkmanager;

  # /var/lib/misc is for dnsmasq.leases.
  stateDirs = "/var/lib/NetworkManager /var/lib/dhclient /var/lib/misc";

  dns =
    if cfg.useDnsmasq then "dnsmasq"
    else if config.services.resolved.enable then "systemd-resolved"
    else if config.services.unbound.enable then "unbound"
    else "default";

  configFile = writeText "NetworkManager.conf" ''
    [main]
    plugins=keyfile
    dhcp=${cfg.dhcp}
    dns=${dns}

    [keyfile]
    ${optionalString (cfg.unmanaged != [])
      ''unmanaged-devices=${lib.concatStringsSep ";" cfg.unmanaged}''}

    [logging]
    level=${cfg.logLevel}

    [connection]
    ipv6.ip6-privacy=2
    ethernet.cloned-mac-address=${cfg.ethernet.macAddress}
    wifi.cloned-mac-address=${cfg.wifi.macAddress}
    ${optionalString (cfg.wifi.powersave != null)
      ''wifi.powersave=${if cfg.wifi.powersave then "3" else "2"}''}

    [device]
    wifi.scan-rand-mac-address=${if cfg.wifi.scanRandMacAddress then "yes" else "no"}
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

  macAddressOpt = mkOption {
    type = types.either types.str (types.enum ["permanent" "preserve" "random" "stable"]);
    default = "preserve";
    example = "00:11:22:33:44:55";
    description = ''
      "XX:XX:XX:XX:XX:XX": MAC address of the interface.
      <literal>permanent</literal>: use the permanent MAC address of the device.
      <literal>preserve</literal>: don’t change the MAC address of the device upon activation.
      <literal>random</literal>: generate a randomized value upon each connect.
      <literal>stable</literal>: generate a stable, hashed MAC address.
    '';
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
                            networkmanager-openvpn networkmanager-vpnc
                            networkmanager-openconnect networkmanager-fortisslvpn
                            networkmanager-pptp networkmanager-l2tp
                            networkmanager-iodine; };
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

      dhcp = mkOption {
        type = types.enum [ "dhclient" "dhcpcd" "internal" ];
        default = "dhclient";
        description = ''
          Which program (or internal library) should be used for DHCP.
        '';
      };

      logLevel = mkOption {
        type = types.enum [ "OFF" "ERR" "WARN" "INFO" "DEBUG" "TRACE" ];
        default = "WARN";
        description = ''
          Set the default logging verbosity level.
        '';
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

      ethernet.macAddress = macAddressOpt;

      wifi = {
        macAddress = macAddressOpt;

        powersave = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = ''
            Whether to enable Wi-Fi power saving.
          '';
        };

        scanRandMacAddress = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to enable MAC address randomization of a Wi-Fi device
            during scanning.
          '';
        };
      };

      useDnsmasq = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable NetworkManager's dnsmasq integration. NetworkManager will run
          dnsmasq as a local caching nameserver, using a "split DNS"
          configuration if you are connected to a VPN, and then update
          resolv.conf to point to the local nameserver.
        '';
      };

      dispatcherScripts = mkOption {
        type = types.listOf (types.submodule {
          options = {
            source = mkOption {
              type = types.path;
              description = ''
                A script.
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

      enableStrongSwan = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the StrongSwan plugin.
          </para><para>
          If you enable this option the
          <literal>networkmanager_strongswan</literal> plugin will be added to
          the <option>networking.networkmanager.packages</option> option
          so you don't need to to that yourself.
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [{
      assertion = config.networking.wireless.enable == false;
      message = "You can not use networking.networkmanager with networking.wireless";
    }];

    boot.kernelModules = [ "ppp_mppe" ]; # Needed for most (all?) PPTP VPN connections.

    environment.etc = with cfg.basePackages; [
      { source = configFile;
        target = "NetworkManager/NetworkManager.conf";
      }
      { source = "${networkmanager-openvpn}/etc/NetworkManager/VPN/nm-openvpn-service.name";
        target = "NetworkManager/VPN/nm-openvpn-service.name";
      }
      { source = "${networkmanager-vpnc}/etc/NetworkManager/VPN/nm-vpnc-service.name";
        target = "NetworkManager/VPN/nm-vpnc-service.name";
      }
      { source = "${networkmanager-openconnect}/etc/NetworkManager/VPN/nm-openconnect-service.name";
        target = "NetworkManager/VPN/nm-openconnect-service.name";
      }
      { source = "${networkmanager-fortisslvpn}/etc/NetworkManager/VPN/nm-fortisslvpn-service.name";
        target = "NetworkManager/VPN/nm-fortisslvpn-service.name";
      }
      { source = "${networkmanager-pptp}/etc/NetworkManager/VPN/nm-pptp-service.name";
        target = "NetworkManager/VPN/nm-pptp-service.name";
      }
      { source = "${networkmanager-l2tp}/etc/NetworkManager/VPN/nm-l2tp-service.name";
        target = "NetworkManager/VPN/nm-l2tp-service.name";
      }
      { source = "${networkmanager_strongswan}/etc/NetworkManager/VPN/nm-strongswan-service.name";
        target = "NetworkManager/VPN/nm-strongswan-service.name";
      }
      { source = "${networkmanager-iodine}/etc/NetworkManager/VPN/nm-iodine-service.name";
        target = "NetworkManager/VPN/nm-iodine-service.name";
      }
    ] ++ optional (cfg.appendNameservers == [] || cfg.insertNameservers == [])
           { source = overrideNameserversScript;
             target = "NetworkManager/dispatcher.d/02overridedns";
           }
      ++ lib.imap1 (i: s: {
        inherit (s) source;
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
      extraGroups = [ "networkmanager" ];
    }
    {
      name = "nm-iodine";
      isSystemUser = true;
      group = "networkmanager";
    }];

    systemd.packages = cfg.packages;

    systemd.services."network-manager" = {
      wantedBy = [ "network.target" ];
      restartTriggers = [ configFile ];

      preStart = ''
        mkdir -m 700 -p /etc/NetworkManager/system-connections
        mkdir -m 700 -p /etc/ipsec.d
        mkdir -m 755 -p ${stateDirs}
      '';
    };

    # Turn off NixOS' network management
    networking = {
      useDHCP = false;
      # use mkDefault to trigger the assertion about the conflict above
      wireless.enable = lib.mkDefault false;
    };

    security.polkit.extraConfig = polkitConf;

    networking.networkmanager.packages =
      mkIf cfg.enableStrongSwan [ pkgs.networkmanager_strongswan ];

    services.dbus.packages =
      optional cfg.enableStrongSwan pkgs.strongswanNM ++ cfg.packages;

    services.udev.packages = cfg.packages;
  };
}
