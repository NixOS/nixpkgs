{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.networkmanager;
  ini = pkgs.formats.ini { };

  delegateWireless = config.networking.wireless.enable == true && cfg.unmanaged != [ ];

  enableIwd = cfg.wifi.backend == "iwd";

  mkValue = v:
    if v == true then "yes"
    else if v == false then "no"
    else if lib.isInt v then toString v
    else v;

  mkSection = name: attrs: ''
    [${name}]
    ${
      lib.concatStringsSep "\n"
        (lib.mapAttrsToList
          (k: v: "${k}=${mkValue v}")
          (lib.filterAttrs
            (k: v: v != null)
            attrs))
    }
  '';

  configFile = pkgs.writeText "NetworkManager.conf" (lib.concatStringsSep "\n" [
    (mkSection "main" {
      plugins = "keyfile";
      inherit (cfg) dhcp dns;
      # If resolvconf is disabled that means that resolv.conf is managed by some other module.
      rc-manager =
        if config.networking.resolvconf.enable then "resolvconf"
        else "unmanaged";
    })
    (mkSection "keyfile" {
      unmanaged-devices =
        if cfg.unmanaged == [ ] then null
        else lib.concatStringsSep ";" cfg.unmanaged;
    })
    (mkSection "logging" {
      audit = config.security.audit.enable;
      level = cfg.logLevel;
    })
    (mkSection "connection" cfg.connectionConfig)
    (mkSection "device" {
      "wifi.scan-rand-mac-address" = cfg.wifi.scanRandMacAddress;
      "wifi.backend" = cfg.wifi.backend;
    })
    cfg.extraConfig
  ]);

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

  ns = xs: pkgs.writeText "nameservers" (
    concatStrings (map (s: "nameserver ${s}\n") xs)
  );

  overrideNameserversScript = pkgs.writeScript "02overridedns" ''
    #!/bin/sh
    PATH=${with pkgs; makeBinPath [ gnused gnugrep coreutils ]}
    tmp=$(mktemp)
    sed '/nameserver /d' /etc/resolv.conf > $tmp
    grep 'nameserver ' /etc/resolv.conf | \
      grep -vf ${ns (cfg.appendNameservers ++ cfg.insertNameservers)} > $tmp.ns
    cat $tmp ${ns cfg.insertNameservers} $tmp.ns ${ns cfg.appendNameservers} > /etc/resolv.conf
    rm -f $tmp $tmp.ns
  '';

  dispatcherTypesSubdirMap = {
    basic = "";
    pre-up = "pre-up.d/";
    pre-down = "pre-down.d/";
  };

  macAddressOpt = mkOption {
    type = types.either types.str (types.enum [ "permanent" "preserve" "random" "stable" ]);
    default = "preserve";
    example = "00:11:22:33:44:55";
    description = lib.mdDoc ''
      Set the MAC address of the interface.

      - `"XX:XX:XX:XX:XX:XX"`: MAC address of the interface
      - `"permanent"`: Use the permanent MAC address of the device
      - `"preserve"`: Don’t change the MAC address of the device upon activation
      - `"random"`: Generate a randomized value upon each connect
      - `"stable"`: Generate a stable, hashed MAC address
    '';
  };

  packages = [
    pkgs.modemmanager
    pkgs.networkmanager
  ]
  ++ cfg.plugins
  ++ lib.optionals (!delegateWireless && !enableIwd) [
    pkgs.wpa_supplicant
  ];

in
{

  meta = {
    maintainers = teams.freedesktop.members;
  };

  ###### interface

  options = {

    networking.networkmanager = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to use NetworkManager to obtain an IP address and other
          configuration for all network interfaces that are not manually
          configured. If enabled, a group `networkmanager`
          will be created. Add all users that should have permission
          to change network settings to this group.
        '';
      };

      connectionConfig = mkOption {
        type = with types; attrsOf (nullOr (oneOf [
          bool
          int
          str
        ]));
        default = { };
        description = lib.mdDoc ''
          Configuration for the [connection] section of NetworkManager.conf.
          Refer to
          [
            https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html#id-1.2.3.11
          ](https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html)
          or
          {manpage}`NetworkManager.conf(5)`
          for more information.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
          Configuration appended to the generated NetworkManager.conf.
          Refer to
          [
            https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html
          ](https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html)
          or
          {manpage}`NetworkManager.conf(5)`
          for more information.
        '';
      };

      unmanaged = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          List of interfaces that will not be managed by NetworkManager.
          Interface name can be specified here, but if you need more fidelity,
          refer to
          [
            https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html#device-spec
          ](https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html#device-spec)
          or the "Device List Format" Appendix of
          {manpage}`NetworkManager.conf(5)`.
        '';
      };

      plugins = mkOption {
        type =
          let
            networkManagerPluginPackage = types.package // {
              description = "NetworkManager plug-in";
              check =
                p:
                lib.assertMsg
                  (types.package.check p
                    && p ? networkManagerPlugin
                    && lib.isString p.networkManagerPlugin)
                  ''
                    Package ‘${p.name}’, is not a NetworkManager plug-in.
                    Those need to have a ‘networkManagerPlugin’ attribute.
                  '';
            };
          in
          types.listOf networkManagerPluginPackage;
        default = [ ];
        description = lib.mdDoc ''
          List of NetworkManager plug-ins to enable.
          Some plug-ins are enabled by the NetworkManager module by default.
        '';
      };

      dhcp = mkOption {
        type = types.enum [ "dhcpcd" "internal" ];
        default = "internal";
        description = lib.mdDoc ''
          Which program (or internal library) should be used for DHCP.
        '';
      };

      logLevel = mkOption {
        type = types.enum [ "OFF" "ERR" "WARN" "INFO" "DEBUG" "TRACE" ];
        default = "WARN";
        description = lib.mdDoc ''
          Set the default logging verbosity level.
        '';
      };

      appendNameservers = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          A list of name servers that should be appended
          to the ones configured in NetworkManager or received by DHCP.
        '';
      };

      insertNameservers = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = lib.mdDoc ''
          A list of name servers that should be inserted before
          the ones configured in NetworkManager or received by DHCP.
        '';
      };

      ethernet.macAddress = macAddressOpt;

      wifi = {
        macAddress = macAddressOpt;

        backend = mkOption {
          type = types.enum [ "wpa_supplicant" "iwd" ];
          default = "wpa_supplicant";
          description = lib.mdDoc ''
            Specify the Wi-Fi backend used for the device.
            Currently supported are {option}`wpa_supplicant` or {option}`iwd` (experimental).
          '';
        };

        powersave = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = lib.mdDoc ''
            Whether to enable Wi-Fi power saving.
          '';
        };

        scanRandMacAddress = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc ''
            Whether to enable MAC address randomization of a Wi-Fi device
            during scanning.
          '';
        };
      };

      dns = mkOption {
        type = types.enum [ "default" "dnsmasq" "unbound" "systemd-resolved" "none" ];
        default = "default";
        description = lib.mdDoc ''
          Set the DNS (`resolv.conf`) processing mode.

          A description of these modes can be found in the main section of
          [
            https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html
          ](https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html)
          or in
          {manpage}`NetworkManager.conf(5)`.
        '';
      };

      dispatcherScripts = mkOption {
        type = types.listOf (types.submodule {
          options = {
            source = mkOption {
              type = types.path;
              description = lib.mdDoc ''
                Path to the hook script.
              '';
            };

            type = mkOption {
              type = types.enum (attrNames dispatcherTypesSubdirMap);
              default = "basic";
              description = lib.mdDoc ''
                Dispatcher hook type. Look up the hooks described at
                [https://developer.gnome.org/NetworkManager/stable/NetworkManager.html](https://developer.gnome.org/NetworkManager/stable/NetworkManager.html)
                and choose the type depending on the output folder.
                You should then filter the event type (e.g., "up"/"down") from within your script.
              '';
            };
          };
        });
        default = [ ];
        example = literalExpression ''
          [ {
            source = pkgs.writeText "upHook" '''
              if [ "$2" != "up" ]; then
                logger "exit: event $2 != up"
                exit
              fi

              # coreutils and iproute are in PATH too
              logger "Device $DEVICE_IFACE coming up"
            ''';
            type = "basic";
          } ]
        '';
        description = lib.mdDoc ''
          A list of scripts which will be executed in response to network events.
        '';
      };

      enableStrongSwan = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable the StrongSwan plugin.

          If you enable this option the
          `networkmanager_strongswan` plugin will be added to
          the {option}`networking.networkmanager.plugins` option
          so you don't need to do that yourself.
        '';
      };

      fccUnlockScripts = mkOption {
        type = types.listOf (types.submodule {
          options = {
            id = mkOption {
              type = types.str;
              description = lib.mdDoc "vid:pid of either the PCI or USB vendor and product ID";
            };
            path = mkOption {
              type = types.path;
              description = lib.mdDoc "Path to the unlock script";
            };
          };
        });
        default = [ ];
        example = literalExpression ''[{ name = "03f0:4e1d"; script = "''${pkgs.modemmanager}/share/ModemManager/fcc-unlock.available.d/03f0:4e1d"; }]'';
        description = lib.mdDoc ''
          List of FCC unlock scripts to enable on the system, behaving as described in
          https://modemmanager.org/docs/modemmanager/fcc-unlock/#integration-with-third-party-fcc-unlock-tools.
        '';
      };
      ensureProfiles = {
        profiles = with lib.types; mkOption {
          type = attrsOf (submodule {
            freeformType = ini.type;

            options = {
              connection = {
                id = lib.mkOption {
                  type = str;
                  description = "This is the name that will be displayed by NetworkManager and GUIs.";
                };
                type = lib.mkOption {
                  type = str;
                  description = "The connection type defines the connection kind, like vpn, wireguard, gsm, wifi and more.";
                  example = "vpn";
                };
              };
            };
          });
          apply = (lib.filterAttrsRecursive (n: v: v != { }));
          default = { };
          example = {
            home-wifi = {
              connection = {
                id = "home-wifi";
                type = "wifi";
                permissions = "";
              };
              wifi = {
                mac-address-blacklist = "";
                mode = "infrastructure";
                ssid = "Home Wi-Fi";
              };
              wifi-security = {
                auth-alg = "open";
                key-mgmt = "wpa-psk";
                psk = "$HOME_WIFI_PASSWORD";
              };
              ipv4 = {
                dns-search = "";
                method = "auto";
              };
              ipv6 = {
                addr-gen-mode = "stable-privacy";
                dns-search = "";
                method = "auto";
              };
            };
          };
          description = lib.mdDoc ''
            Declaratively define NetworkManager profiles. You can find information about the generated file format [here](https://networkmanager.dev/docs/api/latest/nm-settings-keyfile.html) and [here](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/assembly_networkmanager-connection-profiles-in-keyfile-format_configuring-and-managing-networking).
            You current profiles which are most likely stored in `/etc/NetworkManager/system-connections` and there is [a tool](https://github.com/janik-haag/nm2nix) to convert them to the needed nix code.
            If you add a new ad-hoc connection via a GUI or nmtui or anything similar it should just work together with the declarative ones.
            And if you edit a declarative profile NetworkManager will move it to the persistent storage and treat it like a ad-hoc one,
            but there will be two profiles as soon as the systemd unit from this option runs again which can be confusing since NetworkManager tools will start displaying two profiles with the same name and probably a bit different settings depending on what you edited.
            A profile won't be deleted even if it's removed from the config until the system reboots because that's when NetworkManager clears it's temp directory.
          '';
        };
        environmentFiles = mkOption {
          default = [];
          type = types.listOf types.path;
          example = [ "/run/secrets/network-manager.env" ];
          description = lib.mdDoc ''
            Files to load as environment file. Environment variables from this file
            will be substituted into the static configuration file using [envsubst](https://github.com/a8m/envsubst).
          '';
        };
      };
    };
  };

  imports = [
    (mkRenamedOptionModule
      [ "networking" "networkmanager" "packages" ]
      [ "networking" "networkmanager" "plugins" ])
    (mkRenamedOptionModule [ "networking" "networkmanager" "useDnsmasq" ] [ "networking" "networkmanager" "dns" ])
    (mkRemovedOptionModule [ "networking" "networkmanager" "enableFccUnlock" ] ''
      This option was removed, because using bundled FCC unlock scripts is risky,
      might conflict with vendor-provided unlock scripts, and should
      be a conscious decision on a per-device basis.
      Instead it's recommended to use the
      `networking.networkmanager.fccUnlockScripts` option.
    '')
    (mkRemovedOptionModule [ "networking" "networkmanager" "dynamicHosts" ] ''
      This option was removed because allowing (multiple) regular users to
      override host entries affecting the whole system opens up a huge attack
      vector. There seem to be very rare cases where this might be useful.
      Consider setting system-wide host entries using networking.hosts, provide
      them via the DNS server in your network, or use environment.etc
      to add a file into /etc/NetworkManager/dnsmasq.d reconfiguring hostsdir.
    '')
    (mkRemovedOptionModule [ "networking" "networkmanager" "firewallBackend" ] ''
      This option was removed as NixOS is now using iptables-nftables-compat even when using iptables, therefore Networkmanager now uses the nftables backend unconditionally.
    '')
  ];


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = config.networking.wireless.enable == true -> cfg.unmanaged != [ ];
        message = ''
          You can not use networking.networkmanager with networking.wireless.
          Except if you mark some interfaces as <literal>unmanaged</literal> by NetworkManager.
        '';
      }
    ];

    hardware.wirelessRegulatoryDatabase = true;

    environment.etc = {
      "NetworkManager/NetworkManager.conf".source = configFile;
    }
    // builtins.listToAttrs (map
      (pkg: nameValuePair "NetworkManager/${pkg.networkManagerPlugin}" {
        source = "${pkg}/lib/NetworkManager/${pkg.networkManagerPlugin}";
      })
      cfg.plugins)
    // builtins.listToAttrs (map
      (e: nameValuePair "ModemManager/fcc-unlock.d/${e.id}" {
        source = e.path;
      })
      cfg.fccUnlockScripts)
    // optionalAttrs (cfg.appendNameservers != [ ] || cfg.insertNameservers != [ ])
      {
        "NetworkManager/dispatcher.d/02overridedns".source = overrideNameserversScript;
      }
    // listToAttrs (lib.imap1
      (i: s:
        {
          name = "NetworkManager/dispatcher.d/${dispatcherTypesSubdirMap.${s.type}}03userscript${lib.fixedWidthNumber 4 i}";
          value = { mode = "0544"; inherit (s) source; };
        })
      cfg.dispatcherScripts);

    environment.systemPackages = packages;

    users.groups = {
      networkmanager.gid = config.ids.gids.networkmanager;
      nm-openvpn.gid = config.ids.gids.nm-openvpn;
    };

    users.users = {
      nm-openvpn = {
        uid = config.ids.uids.nm-openvpn;
        group = "nm-openvpn";
        extraGroups = [ "networkmanager" ];
      };
      nm-iodine = {
        isSystemUser = true;
        group = "networkmanager";
      };
    };

    systemd.packages = packages;

    systemd.tmpfiles.rules = [
      "d /etc/NetworkManager/system-connections 0700 root root -"
      "d /etc/ipsec.d 0700 root root -"
      "d /var/lib/NetworkManager-fortisslvpn 0700 root root -"

      "d /var/lib/misc 0755 root root -" # for dnsmasq.leases
      # ppp isn't able to mkdir that directory at runtime
      "d /run/pppd/lock 0700 root root -"
    ];

    systemd.services.NetworkManager = {
      wantedBy = [ "network.target" ];
      restartTriggers = [ configFile ];

      aliases = [ "dbus-org.freedesktop.NetworkManager.service" ];

      serviceConfig = {
        StateDirectory = "NetworkManager";
        StateDirectoryMode = 755; # not sure if this really needs to be 755
      };
    };

    systemd.services.NetworkManager-wait-online = {
      wantedBy = [ "network-online.target" ];
    };

    systemd.services.ModemManager = {
      aliases = [ "dbus-org.freedesktop.ModemManager1.service" ];
      path = lib.optionals (cfg.fccUnlockScripts != []) [ pkgs.libqmi pkgs.libmbim ];
    };

    systemd.services.NetworkManager-dispatcher = {
      wantedBy = [ "network.target" ];
      restartTriggers = [ configFile overrideNameserversScript ];

      # useful binaries for user-specified hooks
      path = [ pkgs.iproute2 pkgs.util-linux pkgs.coreutils ];
      aliases = [ "dbus-org.freedesktop.nm-dispatcher.service" ];
    };

    systemd.services.NetworkManager-ensure-profiles = mkIf (cfg.ensureProfiles.profiles != { }) {
      description = "Ensure that NetworkManager declarative profiles are created";
      wantedBy = [ "multi-user.target" ];
      before = [ "network-online.target" ];
      script = let
        path = id: "/run/NetworkManager/system-connections/${id}.nmconnection";
      in ''
        mkdir -p /run/NetworkManager/system-connections
      '' + lib.concatMapStringsSep "\n"
        (profile: ''
          ${pkgs.envsubst}/bin/envsubst -i ${ini.generate (lib.escapeShellArg profile.n) profile.v} > ${path (lib.escapeShellArg profile.n)}
        '') (lib.mapAttrsToList (n: v: { inherit n v; }) cfg.ensureProfiles.profiles)
      + ''
        if systemctl is-active --quiet NetworkManager; then
          ${pkgs.networkmanager}/bin/nmcli connection reload
        fi
      '';
      serviceConfig = {
        EnvironmentFile = cfg.ensureProfiles.environmentFiles;
        UMask = "0177";
        Type = "oneshot";
      };
    };

    # Turn off NixOS' network management when networking is managed entirely by NetworkManager
    networking = mkMerge [
      (mkIf (!delegateWireless) {
        useDHCP = false;
      })

      {
        networkmanager.plugins = with pkgs; [
          networkmanager-fortisslvpn
          networkmanager-iodine
          networkmanager-l2tp
          networkmanager-openconnect
          networkmanager-openvpn
          networkmanager-vpnc
          networkmanager-sstp
        ];
      }

      (mkIf cfg.enableStrongSwan {
        networkmanager.plugins = [ pkgs.networkmanager_strongswan ];
      })

      (mkIf enableIwd {
        wireless.iwd.enable = true;
      })

      {
        networkmanager.connectionConfig = {
          "ethernet.cloned-mac-address" = cfg.ethernet.macAddress;
          "wifi.cloned-mac-address" = cfg.wifi.macAddress;
          "wifi.powersave" =
            if cfg.wifi.powersave == null then null
            else if cfg.wifi.powersave then 3
            else 2;
        };
      }
    ];

    boot.kernelModules = [ "ctr" ];

    security.polkit.enable = true;
    security.polkit.extraConfig = polkitConf;

    services.dbus.packages = packages
      ++ optional cfg.enableStrongSwan pkgs.strongswanNM
      ++ optional (cfg.dns == "dnsmasq") pkgs.dnsmasq;

    services.udev.packages = packages;
  };
}
