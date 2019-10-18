{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.networkmanager;

  basePackages = with pkgs; [
    crda
    modemmanager
    networkmanager
    networkmanager-fortisslvpn
    networkmanager-iodine
    networkmanager-l2tp
    networkmanager-openconnect
    networkmanager-openvpn
    networkmanager-vpnc
  ] ++ optional (!enableIwd) wpa_supplicant;

  dynamicHostsEnabled =
    cfg.dynamicHosts.enable && cfg.dynamicHosts.hostsDirs != {};

  enableIwd = cfg.wifi.backend == "iwd";

  # /var/lib/misc is for dnsmasq.leases.
  stateDirs = "/var/lib/NetworkManager /var/lib/dhclient /var/lib/misc /var/lib/NetworkManager-fortisslvpn";

  configFile = pkgs.writeText "NetworkManager.conf" ''
    [main]
    plugins=keyfile
    dhcp=${cfg.dhcp}
    dns=${cfg.dns}
    # If resolvconf is disabled that means that resolv.conf is managed by some other module.
    rc-manager=${if config.networking.resolvconf.enable then "resolvconf" else "unmanaged"}

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
    wifi.backend=${cfg.wifi.backend}

    ${cfg.extraConfig}
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
    type = types.either types.str (types.enum ["permanent" "preserve" "random" "stable"]);
    default = "preserve";
    example = "00:11:22:33:44:55";
    description = ''
      Set the MAC address of the interface.
      <variablelist>
        <varlistentry>
          <term>"XX:XX:XX:XX:XX:XX"</term>
          <listitem><para>MAC address of the interface</para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"permanent"</literal></term>
          <listitem><para>Use the permanent MAC address of the device</para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"preserve"</literal></term>
          <listitem><para>Don’t change the MAC address of the device upon activation</para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"random"</literal></term>
          <listitem><para>Generate a randomized value upon each connect</para></listitem>
        </varlistentry>
        <varlistentry>
          <term><literal>"stable"</literal></term>
          <listitem><para>Generate a stable, hashed MAC address</para></listitem>
        </varlistentry>
      </variablelist>
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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration appended to the generated NetworkManager.conf.
          Refer to
          <link xlink:href="https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html">
            https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html
          </link>
          or
          <citerefentry>
            <refentrytitle>NetworkManager.conf</refentrytitle>
            <manvolnum>5</manvolnum>
          </citerefentry>
          for more information.
        '';
      };

      unmanaged = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          List of interfaces that will not be managed by NetworkManager.
          Interface name can be specified here, but if you need more fidelity,
          refer to
          <link xlink:href="https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html#device-spec">
            https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html#device-spec
          </link>
          or the "Device List Format" Appendix of
          <citerefentry>
            <refentrytitle>NetworkManager.conf</refentrytitle>
            <manvolnum>5</manvolnum>
          </citerefentry>.
        '';
      };

      packages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        description = ''
          Extra packages that provide NetworkManager plugins.
        '';
        apply = list: basePackages ++ list;
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

        backend = mkOption {
          type = types.enum [ "wpa_supplicant" "iwd" ];
          default = "wpa_supplicant";
          description = ''
            Specify the Wi-Fi backend used for the device.
            Currently supported are <option>wpa_supplicant</option> or <option>iwd</option> (experimental).
          '';
        };

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

      dns = mkOption {
        type = types.enum [ "default" "dnsmasq" "unbound" "systemd-resolved" "none" ];
        default = "default";
        description = ''
          Set the DNS (<literal>resolv.conf</literal>) processing mode.
          </para>
          <para>
          A description of these modes can be found in the main section of
          <link xlink:href="https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html">
            https://developer.gnome.org/NetworkManager/stable/NetworkManager.conf.html
          </link>
          or in
          <citerefentry>
            <refentrytitle>NetworkManager.conf</refentrytitle>
            <manvolnum>5</manvolnum>
          </citerefentry>.
        '';
      };

      dispatcherScripts = mkOption {
        type = types.listOf (types.submodule {
          options = {
            source = mkOption {
              type = types.path;
              description = ''
                Path to the hook script.
              '';
            };

            type = mkOption {
              type = types.enum (attrNames dispatcherTypesSubdirMap);
              default = "basic";
              description = ''
                Dispatcher hook type. Look up the hooks described at
                <link xlink:href="https://developer.gnome.org/NetworkManager/stable/NetworkManager.html">https://developer.gnome.org/NetworkManager/stable/NetworkManager.html</link>
                and choose the type depending on the output folder.
                You should then filter the event type (e.g., "up"/"down") from within your script.
              '';
            };
          };
        });
        default = [];
        example = literalExample ''
        [ {
              source = pkgs.writeText "upHook" '''

                if [ "$2" != "up" ]; then
                    logger "exit: event $2 != up"
                fi

                # coreutils and iproute are in PATH too
                logger "Device $DEVICE_IFACE coming up"
            ''';
            type = "basic";
        } ]'';
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

      dynamicHosts = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enabling this option requires the
            <option>networking.networkmanager.dns</option> option to be
            set to <literal>dnsmasq</literal>. If enabled, the directories
            defined by the
            <option>networking.networkmanager.dynamicHosts.hostsDirs</option>
            option will be set up when the service starts. The dnsmasq instance
            managed by NetworkManager will then watch those directories for
            hosts files (see the <literal>--hostsdir</literal> option of
            dnsmasq). This way a non-privileged user can add or override DNS
            entries on the local system (depending on what hosts directories
            that are configured)..
          '';
        };
        hostsDirs = mkOption {
          type = with types; attrsOf (submodule {
            options = {
              user = mkOption {
                type = types.str;
                default = "root";
                description = ''
                  The user that will own the hosts directory.
                '';
              };
              group = mkOption {
                type = types.str;
                default = "root";
                description = ''
                  The group that will own the hosts directory.
                '';
              };
            };
          });
          default = {};
          description = ''
            Defines a set of directories (relative to
            <literal>/run/NetworkManager/hostdirs</literal>) that dnsmasq will
            watch for hosts files.
          '';
        };
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      { assertion = config.networking.wireless.enable == false;
        message = "You can not use networking.networkmanager with networking.wireless";
      }
      { assertion = !dynamicHostsEnabled || (dynamicHostsEnabled && cfg.dns == "dnsmasq");
        message = ''
          To use networking.networkmanager.dynamicHosts you also need to set
          networking.networkmanager.dns = "dnsmasq"
        '';
      }
    ];

    environment.etc = with pkgs; [
      { source = configFile;
        target = "NetworkManager/NetworkManager.conf";
      }
      { source = "${networkmanager-openvpn}/lib/NetworkManager/VPN/nm-openvpn-service.name";
        target = "NetworkManager/VPN/nm-openvpn-service.name";
      }
      { source = "${networkmanager-vpnc}/lib/NetworkManager/VPN/nm-vpnc-service.name";
        target = "NetworkManager/VPN/nm-vpnc-service.name";
      }
      { source = "${networkmanager-openconnect}/lib/NetworkManager/VPN/nm-openconnect-service.name";
        target = "NetworkManager/VPN/nm-openconnect-service.name";
      }
      { source = "${networkmanager-fortisslvpn}/lib/NetworkManager/VPN/nm-fortisslvpn-service.name";
        target = "NetworkManager/VPN/nm-fortisslvpn-service.name";
      }
      { source = "${networkmanager-l2tp}/lib/NetworkManager/VPN/nm-l2tp-service.name";
        target = "NetworkManager/VPN/nm-l2tp-service.name";
      }
      { source = "${networkmanager-iodine}/lib/NetworkManager/VPN/nm-iodine-service.name";
        target = "NetworkManager/VPN/nm-iodine-service.name";
      }
    ] ++ optional (cfg.appendNameservers != [] || cfg.insertNameservers != [])
           { source = overrideNameserversScript;
             target = "NetworkManager/dispatcher.d/02overridedns";
           }
      ++ lib.imap1 (i: s: {
        inherit (s) source;
        target = "NetworkManager/dispatcher.d/${dispatcherTypesSubdirMap.${s.type}}03userscript${lib.fixedWidthNumber 4 i}";
        mode = "0544";
      }) cfg.dispatcherScripts
      ++ optional dynamicHostsEnabled
           { target = "NetworkManager/dnsmasq.d/dyndns.conf";
             text = concatMapStrings (n: ''
               hostsdir=/run/NetworkManager/hostsdirs/${n}
             '') (attrNames cfg.dynamicHosts.hostsDirs);
           }
      ++ optional cfg.enableStrongSwan
           { source = "${pkgs.networkmanager_strongswan}/lib/NetworkManager/VPN/nm-strongswan-service.name";
             target = "NetworkManager/VPN/nm-strongswan-service.name";
           };

    environment.systemPackages = cfg.packages;

    users.groups = [{
      name = "networkmanager";
      gid = config.ids.gids.networkmanager;
    }
    {
      name = "nm-openvpn";
      gid = config.ids.gids.nm-openvpn;
    }];
    users.users = [{
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

    systemd.services.NetworkManager = {
      wantedBy = [ "network.target" ];
      restartTriggers = [ configFile ];

      preStart = ''
        mkdir -m 700 -p /etc/NetworkManager/system-connections
        mkdir -m 700 -p /etc/ipsec.d
        mkdir -m 755 -p ${stateDirs}
      '';

      aliases = [
        "dbus-org.freedesktop.NetworkManager.service"
        "network-manager.service"
      ];
    };

    systemd.services.NetworkManager-wait-online = {
      wantedBy = [ "network-online.target" ];
    };

    systemd.services.ModemManager.aliases = [
      "dbus-org.freedesktop.ModemManager1.service"
      "modem-manager.service"
    ];

    systemd.services.nm-setup-hostsdirs = mkIf dynamicHostsEnabled {
      wantedBy = [ "NetworkManager.service" ];
      before = [ "NetworkManager.service" ];
      partOf = [ "NetworkManager.service" ];
      script = concatStrings (mapAttrsToList (n: d: ''
        mkdir -p "/run/NetworkManager/hostsdirs/${n}"
        chown "${d.user}:${d.group}" "/run/NetworkManager/hostsdirs/${n}"
        chmod 0775 "/run/NetworkManager/hostsdirs/${n}"
      '') cfg.dynamicHosts.hostsDirs);
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };

    systemd.services.NetworkManager-dispatcher = {
      wantedBy = [ "network.target" ];
      restartTriggers = [ configFile ];

      # useful binaries for user-specified hooks
      path = [ pkgs.iproute pkgs.utillinux pkgs.coreutils ];
      aliases = [ "dbus-org.freedesktop.nm-dispatcher.service" ];
    };

    # Turn off NixOS' network management
    networking = {
      useDHCP = false;
      # use mkDefault to trigger the assertion about the conflict above
      wireless.enable = mkDefault false;
    } // (mkIf cfg.enableStrongSwan {
      networkmanager.packages = [ pkgs.networkmanager_strongswan ];
    }) // (mkIf enableIwd {
      wireless.iwd.enable = true;
    });

    security.polkit.extraConfig = polkitConf;

    services.dbus.packages =
      optional cfg.enableStrongSwan pkgs.strongswanNM ++ cfg.packages;

    services.udev.packages = cfg.packages;
  };
}
