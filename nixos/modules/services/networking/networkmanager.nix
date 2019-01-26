{ config, lib, pkgs, ... }:

with pkgs;
with lib;

let
  cfg = config.networking.networkmanager;

  dynamicHostsEnabled =
    cfg.dynamicHosts.enable && cfg.dynamicHosts.hostsDirs != {};

  # /var/lib/misc is for dnsmasq.leases.
  stateDirs = "/var/lib/NetworkManager /var/lib/dhclient /var/lib/misc";

  configFile = writeText "NetworkManager.conf" ''
    [main]
    plugins=keyfile
    dhcp=${cfg.dhcp}
    dns=${cfg.dns}

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

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Configuration appended to the generated NetworkManager.conf.
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
                            networkmanager-l2tp networkmanager-iodine; };
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

      dns = mkOption {
        type = types.enum [ "default" "dnsmasq" "unbound" "systemd-resolved" "none" ];
        default = "default";
        description = ''
          Set the DNS (<literal>resolv.conf</literal>) processing mode.
          </para>
          <para>
          Options:
          <variablelist>
          <varlistentry>
            <term><literal>"default"</literal></term>
            <listitem><para>
              NetworkManager will update <literal>/etc/resolv.conf</literal> to
              reflect the nameservers provided by currently active connections.
            </para></listitem>
          </varlistentry>
          <varlistentry>
            <term><literal>"dnsmasq"</literal></term>
            <listitem>
              <para>
                Enable NetworkManager's dnsmasq integration. NetworkManager will
                run dnsmasq as a local caching nameserver, using a "split DNS"
                configuration if you are connected to a VPN, and then update
                <literal>resolv.conf</literal> to point to the local nameserver.
              </para>
              <para>
                It is possible to pass custom options to the dnsmasq instance by
                adding them to files in the
                <literal>/etc/NetworkManager/dnsmasq.d/</literal> directory.
              </para>
              <para>
                When multiple upstream servers are available, dnsmasq will
                initially contact them in parallel and then use the fastest to
                respond, probing again other servers after some time.  This
                behavior can be modified passing the
                <literal>all-servers</literal> or <literal>strict-order</literal>
                options to dnsmasq (see the manual page for more details).
              </para>
              <para>
                Note that this option causes NetworkManager to launch and manage
                its own instance of the dnsmasq daemon, which is
                <emphasis>not</emphasis> the same as setting
                <literal>services.dnsmasq.enable = true;</literal>.
              </para>
            </listitem>
          </varlistentry>
          <varlistentry>
            <term><literal>"unbound"</literal></term>
            <listitem><para>
              NetworkManager will talk to unbound and dnssec-triggerd,
              providing a "split DNS" configuration with DNSSEC support.
              <literal>/etc/resolv.conf</literal> will be managed by
              dnssec-trigger daemon.
            </para></listitem>
          </varlistentry>
          <varlistentry>
            <term><literal>"systemd-resolved"</literal></term>
            <listitem><para>
              NetworkManager will push the DNS configuration to systemd-resolved.
            </para></listitem>
          </varlistentry>
          <varlistentry>
            <term><literal>"none"</literal></term>
            <listitem><para>
              NetworkManager will not modify resolv.conf.
            </para></listitem>
          </varlistentry>
          </variablelist>
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

    environment.etc = with cfg.basePackages; [
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
      { source = "${networkmanager_strongswan}/lib/NetworkManager/VPN/nm-strongswan-service.name";
        target = "NetworkManager/VPN/nm-strongswan-service.name";
      }
      { source = "${networkmanager-iodine}/lib/NetworkManager/VPN/nm-iodine-service.name";
        target = "NetworkManager/VPN/nm-iodine-service.name";
      }
    ] ++ optional (cfg.appendNameservers == [] || cfg.insertNameservers == [])
           { source = overrideNameserversScript;
             target = "NetworkManager/dispatcher.d/02overridedns";
           }
      ++ lib.imap1 (i: s: {
        inherit (s) source;
        target = "NetworkManager/dispatcher.d/${dispatcherTypesSubdirMap.${s.type}}03userscript${lib.fixedWidthNumber 4 i}";
        mode = "0544";
      }) cfg.dispatcherScripts
      ++ optional (dynamicHostsEnabled)
           { target = "NetworkManager/dnsmasq.d/dyndns.conf";
             text = concatMapStrings (n: ''
               hostsdir=/run/NetworkManager/hostsdirs/${n}
             '') (attrNames cfg.dynamicHosts.hostsDirs);
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

    systemd.services."network-manager" = {
      wantedBy = [ "network.target" ];
      restartTriggers = [ configFile ];

      preStart = ''
        mkdir -m 700 -p /etc/NetworkManager/system-connections
        mkdir -m 700 -p /etc/ipsec.d
        mkdir -m 755 -p ${stateDirs}
      '';
    };

    systemd.services.nm-setup-hostsdirs = mkIf dynamicHostsEnabled {
      wantedBy = [ "network-manager.service" ];
      before = [ "network-manager.service" ];
      partOf = [ "network-manager.service" ];
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

    systemd.services."NetworkManager-dispatcher" = {
      wantedBy = [ "network.target" ];
      restartTriggers = [ configFile ];

      # useful binaries for user-specified hooks
      path = [ pkgs.iproute pkgs.utillinux pkgs.coreutils ];
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
