{
  config,
  lib,
  pkgs,
  ...
}:
let

  dhcpcd =
    if !config.boot.isContainer then
      pkgs.dhcpcd
    else
      pkgs.dhcpcd.override {
        withUdev = false;
      };

  cfg = config.networking.dhcpcd;

  interfaces = lib.attrValues config.networking.interfaces;

  enableDHCP =
    config.networking.dhcpcd.enable
    && (config.networking.useDHCP || lib.any (i: i.useDHCP == true) interfaces);

  useResolvConf = config.networking.resolvconf.enable;

  # Don't start dhcpcd on explicitly configured interfaces or on
  # interfaces that are part of a bridge, bond or sit device.
  ignoredInterfaces =
    map (i: i.name) (
      lib.filter (i: if i.useDHCP != null then !i.useDHCP else i.ipv4.addresses != [ ]) interfaces
    )
    ++ lib.attrNames config.networking.sits
    ++ lib.concatLists (lib.attrValues (lib.mapAttrs (n: v: v.interfaces) config.networking.bridges))
    ++ lib.flatten (
      lib.concatMap (
        i: lib.attrNames (lib.filterAttrs (_: config: config.type != "internal") i.interfaces)
      ) (lib.attrValues config.networking.vswitches)
    )
    ++ lib.concatLists (lib.attrValues (lib.mapAttrs (n: v: v.interfaces) config.networking.bonds))
    ++ config.networking.dhcpcd.denyInterfaces;

  arrayAppendOrNull =
    a1: a2:
    if a1 == null && a2 == null then
      null
    else if a1 == null then
      a2
    else if a2 == null then
      a1
    else
      a1 ++ a2;

  # If dhcp is disabled but explicit interfaces are enabled,
  # we need to provide dhcp just for those interfaces.
  allowInterfaces = arrayAppendOrNull cfg.allowInterfaces (
    if !config.networking.useDHCP && enableDHCP then
      map (i: i.name) (lib.filter (i: i.useDHCP == true) interfaces)
    else
      null
  );

  staticIPv6Addresses = map (i: i.name) (lib.filter (i: i.ipv6.addresses != [ ]) interfaces);

  noIPv6rs = lib.concatStringsSep "\n" (
    map (name: ''
      interface ${name}
      noipv6rs
    '') staticIPv6Addresses
  );

  # Config file adapted from the one that ships with dhcpcd.
  dhcpcdConf = pkgs.writeText "dhcpcd.conf" ''
    # Inform the DHCP server of our hostname for DDNS.
    hostname

    # A list of options to request from the DHCP server.
    option domain_name_servers, domain_name, domain_search
    option classless_static_routes, ntp_servers, interface_mtu

    # A ServerID is required by RFC2131.
    # Commented out because of many non-compliant DHCP servers in the wild :(
    #require dhcp_server_identifier

    # A hook script is provided to lookup the hostname if not set by
    # the DHCP server, but it should not be run by default.
    nohook lookup-hostname

    # Ignore peth* devices; on Xen, they're renamed physical
    # Ethernet cards used for bridging.  Likewise for vif* and tap*
    # (Xen) and virbr* and vnet* (libvirt).
    denyinterfaces ${toString ignoredInterfaces} lo peth* vif* tap* tun* virbr* vnet* vboxnet* sit*

    # Use the list of allowed interfaces if specified
    ${lib.optionalString (allowInterfaces != null) "allowinterfaces ${toString allowInterfaces}"}

    # Immediately fork to background if specified, otherwise wait for IP address to be assigned
    ${
      {
        background = "background";
        any = "waitip";
        ipv4 = "waitip 4";
        ipv6 = "waitip 6";
        both = "waitip 4\nwaitip 6";
        if-carrier-up = "";
      }
      .${cfg.wait}
    }

    ${lib.optionalString (config.networking.enableIPv6 == false) ''
      # Don't solicit or accept IPv6 Router Advertisements and DHCPv6 if disabled IPv6
      noipv6
    ''}

    ${lib.optionalString (
      config.networking.enableIPv6 && cfg.IPv6rs == null && staticIPv6Addresses != [ ]
    ) noIPv6rs}
    ${lib.optionalString (config.networking.enableIPv6 && cfg.IPv6rs == false) ''
      noipv6rs
    ''}
    ${lib.optionalString cfg.setHostname "option host_name"}

    ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    networking.dhcpcd.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to enable dhcpcd for device configuration. This is mainly to
        explicitly disable dhcpcd (for example when using networkd).
      '';
    };

    networking.dhcpcd.persistent = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to leave interfaces configured on dhcpcd daemon
        shutdown. Set to true if you have your root or store mounted
        over the network or this machine accepts SSH connections
        through DHCP interfaces and clients should be notified when
        it shuts down.
      '';
    };

    networking.dhcpcd.setHostname = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to set the machine hostname based on the information
        received from the DHCP server.

        ::: {.note}
        The hostname will be changed only if the current one is
        the empty string, `localhost` or `nixos`.

        Polkit ([](#opt-security.polkit.enable)) is also required.
        :::
      '';
    };

    networking.dhcpcd.denyInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Disable the DHCP client for any interface whose name matches
        any of the shell glob patterns in this list. The purpose of
        this option is to blacklist virtual interfaces such as those
        created by Xen, libvirt, LXC, etc.
      '';
    };

    networking.dhcpcd.allowInterfaces = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
      description = ''
        Enable the DHCP client for any interface whose name matches
        any of the shell glob patterns in this list. Any interface not
        explicitly matched by this pattern will be denied. This pattern only
        applies when non-null.
      '';
    };

    networking.dhcpcd.extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Literal string to append to the config file generated for dhcpcd.
      '';
    };

    networking.dhcpcd.IPv6rs = lib.mkOption {
      type = lib.types.nullOr lib.types.bool;
      default = null;
      description = ''
        Force enable or disable solicitation and receipt of IPv6 Router Advertisements.
        This is required, for example, when using a static unique local IPv6 address (ULA)
        and global IPv6 address auto-configuration with SLAAC.
      '';
    };

    networking.dhcpcd.allowSetuid = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to relax the security sandbox to allow running setuid
        binaries (e.g. `sudo`) in the dhcpcd hooks.
      '';
    };

    networking.dhcpcd.runHook = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = "if [[ $reason =~ BOUND ]]; then echo $interface: Routers are $new_routers - were $old_routers; fi";
      description = ''
        Shell code that will be run after all other hooks. See
        `man dhcpcd-run-hooks` for details on what is possible.

        ::: {.note}
        To use sudo or similar tools in your script you may have to set:

            networking.dhcpcd.allowSetuid = true;

        In addition, as most of the filesystem is inaccessible to dhcpcd
        by default, you may want to define some exceptions, e.g.

            systemd.services.dhcpcd.serviceConfig.ReadOnlyPaths = [
              "/run/user/1000/bus"  # to send desktop notifications
            ];
        :::
      '';
    };

    networking.dhcpcd.wait = lib.mkOption {
      type = lib.types.enum [
        "background"
        "any"
        "ipv4"
        "ipv6"
        "both"
        "if-carrier-up"
      ];
      default = "any";
      description = ''
        This option specifies when the dhcpcd service will fork to background.
        If set to "background", dhcpcd will fork to background immediately.
        If set to "ipv4" or "ipv6", dhcpcd will wait for the corresponding IP
        address to be assigned. If set to "any", dhcpcd will wait for any type
        (IPv4 or IPv6) to be assigned. If set to "both", dhcpcd will wait for
        both an IPv4 and an IPv6 address before forking.
        The option "if-carrier-up" is equivalent to "any" if either ethernet
        is plugged or WiFi is powered, and to "background" otherwise.
      '';
    };

  };

  ###### implementation

  config = lib.mkIf enableDHCP {

    systemd.services.dhcpcd =
      let
        cfgN = config.networking;
        hasDefaultGatewaySet =
          (cfgN.defaultGateway != null && cfgN.defaultGateway.address != "")
          && (!cfgN.enableIPv6 || (cfgN.defaultGateway6 != null && cfgN.defaultGateway6.address != ""));
      in
      {
        description = "DHCP Client";

        documentation = [ "man:dhcpcd(8)" ];

        wantedBy = [ "multi-user.target" ] ++ lib.optional (!hasDefaultGatewaySet) "network-online.target";
        wants = [
          "network.target"
          "resolvconf.service"
        ];
        after = [ "resolvconf.service" ];
        before = [ "network-online.target" ];

        restartTriggers = [ cfg.runHook ];

        # Stopping dhcpcd during a reconfiguration is undesirable
        # because it brings down the network interfaces configured by
        # dhcpcd.  So do a "systemctl restart" instead.
        stopIfChanged = false;

        path = [
          dhcpcd
          config.networking.resolvconf.package
        ]
        ++ lib.optional cfg.setHostname (
          pkgs.writeShellScriptBin "hostname" ''
            ${lib.getExe' pkgs.systemd "hostnamectl"} set-hostname --transient $1
          ''
        );

        unitConfig.ConditionCapability = "CAP_NET_ADMIN";

        serviceConfig = {
          Type = "forking";
          PIDFile = "/run/dhcpcd/pid";
          SupplementaryGroups = lib.optional useResolvConf "resolvconf";
          User = "dhcpcd";
          Group = "dhcpcd";
          StateDirectory = "dhcpcd";
          RuntimeDirectory = "dhcpcd";

          ExecStartPre = "+${pkgs.writeShellScript "migrate-dhcpcd" ''
            # migrate from old database directory
            if test -f /var/db/dhcpcd/duid; then
              echo 'migrating DHCP leases from /var/db/dhcpcd to /var/lib/dhcpcd ...'
              mv /var/db/dhcpcd/* -t /var/lib/dhcpcd
              chown dhcpcd:dhcpcd /var/lib/dhcpcd/*
              rmdir /var/db/dhcpcd || true
              echo done
            fi
          ''}";

          ExecStart = "@${dhcpcd}/sbin/dhcpcd dhcpcd --quiet ${lib.optionalString cfg.persistent "--persistent"} --config ${dhcpcdConf}";
          ExecReload = "${dhcpcd}/sbin/dhcpcd --rebind";
          Restart = "always";
          AmbientCapabilities = [
            "CAP_NET_ADMIN"
            "CAP_NET_RAW"
            "CAP_NET_BIND_SERVICE"
          ];
          CapabilityBoundingSet = lib.optionals (!cfg.allowSetuid) [
            "CAP_NET_ADMIN"
            "CAP_NET_RAW"
            "CAP_NET_BIND_SERVICE"
          ];
          ReadWritePaths = [
            "/proc/sys/net/ipv4"
          ]
          ++ lib.optional cfgN.enableIPv6 "/proc/sys/net/ipv6"
          ++ lib.optionals useResolvConf (
            [ "/run/resolvconf" ] ++ config.networking.resolvconf.subscriberFiles
          );
          DeviceAllow = "";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = lib.mkDefault (!cfg.allowSetuid); # may be disabled for sudo in runHook
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateTmp = true;
          PrivateUsers = false;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = "tmpfs"; # allow exceptions to be added to ReadOnlyPaths, etc.
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_PACKET"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallFilter = [
            "@system-service"
            "~@aio"
            "~@keyring"
            "~@memlock"
            "~@mount"
          ]
          ++ lib.optionals (!cfg.allowSetuid) [
            "~@privileged"
            "~@resources"
          ];
          SystemCallArchitectures = "native";
          UMask = "0027";
        };
      };

    # Note: the service could run with `DynamicUser`, however that makes
    # impossible (for no good reason, see systemd issue #20495) to disable
    # `NoNewPrivileges` or `ProtectHome`, which users may want to in order
    # to run certain scripts in `networking.dhcpcd.runHook`.
    users.users.dhcpcd = {
      isSystemUser = true;
      group = "dhcpcd";
    };
    users.groups.dhcpcd = { };

    environment.systemPackages = [ dhcpcd ];

    environment.etc."dhcpcd.exit-hook".text = cfg.runHook;

    powerManagement.resumeCommands = lib.mkIf config.systemd.services.dhcpcd.enable ''
      # Tell dhcpcd to rebind its interfaces if it's running.
      /run/current-system/systemd/bin/systemctl reload dhcpcd.service
    '';

    security.polkit.extraConfig = lib.mkMerge [
      (lib.mkIf config.services.resolved.enable ''
        polkit.addRule(function(action, subject) {
            if (action.id == 'org.freedesktop.resolve1.revert' ||
                action.id == 'org.freedesktop.resolve1.set-dns-servers' ||
                action.id == 'org.freedesktop.resolve1.set-domains') {
                if (subject.user == 'dhcpcd') {
                    return polkit.Result.YES;
                }
            }
        });
      '')
      (lib.mkIf cfg.setHostname ''
        polkit.addRule(function(action, subject) {
            if (action.id == 'org.freedesktop.hostname1.set-hostname' &&
                subject.user == 'dhcpcd') {
                return polkit.Result.YES;
            }
        });
      '')
    ];

  };

}
