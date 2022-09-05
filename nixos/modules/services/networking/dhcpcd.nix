{ config, lib, pkgs, ... }:

with lib;

let

  dhcpcd = if !config.boot.isContainer then pkgs.dhcpcd else pkgs.dhcpcd.override { udev = null; };

  cfg = config.networking.dhcpcd;

  interfaces = attrValues config.networking.interfaces;

  enableDHCP = config.networking.dhcpcd.enable &&
        (config.networking.useDHCP || any (i: i.useDHCP == true) interfaces);

  # Don't start dhcpcd on explicitly configured interfaces or on
  # interfaces that are part of a bridge, bond or sit device.
  ignoredInterfaces =
    map (i: i.name) (filter (i: if i.useDHCP != null then !i.useDHCP else i.ipv4.addresses != [ ]) interfaces)
    ++ mapAttrsToList (i: _: i) config.networking.sits
    ++ concatLists (attrValues (mapAttrs (n: v: v.interfaces) config.networking.bridges))
    ++ flatten (concatMap (i: attrNames (filterAttrs (_: config: config.type != "internal") i.interfaces)) (attrValues config.networking.vswitches))
    ++ concatLists (attrValues (mapAttrs (n: v: v.interfaces) config.networking.bonds))
    ++ config.networking.dhcpcd.denyInterfaces;

  arrayAppendOrNull = a1: a2: if a1 == null && a2 == null then null
    else if a1 == null then a2 else if a2 == null then a1
      else a1 ++ a2;

  # If dhcp is disabled but explicit interfaces are enabled,
  # we need to provide dhcp just for those interfaces.
  allowInterfaces = arrayAppendOrNull cfg.allowInterfaces
    (if !config.networking.useDHCP && enableDHCP then
      map (i: i.name) (filter (i: i.useDHCP == true) interfaces) else null);

  # Config file adapted from the one that ships with dhcpcd.
  dhcpcdConf = pkgs.writeText "dhcpcd.conf"
    ''
      # Inform the DHCP server of our hostname for DDNS.
      hostname

      # A list of options to request from the DHCP server.
      option domain_name_servers, domain_name, domain_search, host_name
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
      ${optionalString (allowInterfaces != null) "allowinterfaces ${toString allowInterfaces}"}

      # Immediately fork to background if specified, otherwise wait for IP address to be assigned
      ${{
        background = "background";
        any = "waitip";
        ipv4 = "waitip 4";
        ipv6 = "waitip 6";
        both = "waitip 4\nwaitip 6";
        if-carrier-up = "";
      }.${cfg.wait}}

      ${optionalString (config.networking.enableIPv6 == false) ''
        # Don't solicit or accept IPv6 Router Advertisements and DHCPv6 if disabled IPv6
        noipv6
      ''}

      ${cfg.extraConfig}
    '';

  exitHook = pkgs.writeText "dhcpcd.exit-hook"
    ''
      if [ "$reason" = BOUND -o "$reason" = REBOOT ]; then
          # Restart ntpd.  We need to restart it to make sure that it
          # will actually do something: if ntpd cannot resolve the
          # server hostnames in its config file, then it will never do
          # anything ever again ("couldn't resolve ..., giving up on
          # it"), so we silently lose time synchronisation. This also
          # applies to openntpd.
          /run/current-system/systemd/bin/systemctl try-reload-or-restart ntpd.service openntpd.service chronyd.service || true
      fi

      ${cfg.runHook}
    '';

in

{

  ###### interface

  options = {

    networking.dhcpcd.enable = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to enable dhcpcd for device configuration. This is mainly to
        explicitly disable dhcpcd (for example when using networkd).
      '';
    };

    networking.dhcpcd.persistent = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
          Whenever to leave interfaces configured on dhcpcd daemon
          shutdown. Set to true if you have your root or store mounted
          over the network or this machine accepts SSH connections
          through DHCP interfaces and clients should be notified when
          it shuts down.
      '';
    };

    networking.dhcpcd.denyInterfaces = mkOption {
      type = types.listOf types.str;
      default = [];
      description = lib.mdDoc ''
         Disable the DHCP client for any interface whose name matches
         any of the shell glob patterns in this list. The purpose of
         this option is to blacklist virtual interfaces such as those
         created by Xen, libvirt, LXC, etc.
      '';
    };

    networking.dhcpcd.allowInterfaces = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = lib.mdDoc ''
         Enable the DHCP client for any interface whose name matches
         any of the shell glob patterns in this list. Any interface not
         explicitly matched by this pattern will be denied. This pattern only
         applies when non-null.
      '';
    };

    networking.dhcpcd.extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
         Literal string to append to the config file generated for dhcpcd.
      '';
    };

    networking.dhcpcd.runHook = mkOption {
      type = types.lines;
      default = "";
      example = "if [[ $reason =~ BOUND ]]; then echo $interface: Routers are $new_routers - were $old_routers; fi";
      description = lib.mdDoc ''
         Shell code that will be run after all other hooks. See
         `man dhcpcd-run-hooks` for details on what is possible.
      '';
    };

    networking.dhcpcd.wait = mkOption {
      type = types.enum [ "background" "any" "ipv4" "ipv6" "both" "if-carrier-up" ];
      default = "any";
      description = lib.mdDoc ''
        This option specifies when the dhcpcd service will fork to background.
        If set to "background", dhcpcd will fork to background immediately.
        If set to "ipv4" or "ipv6", dhcpcd will wait for the corresponding IP
        address to be assigned. If set to "any", dhcpcd will wait for any type
        (IPv4 or IPv6) to be assigned. If set to "both", dhcpcd will wait for
        both an IPv4 and an IPv6 address before forking.
        The option "if-carrier-up" is equivalent to "any" if either ethernet
        is plugged nor WiFi is powered, and to "background" otherwise.
      '';
    };

  };


  ###### implementation

  config = mkIf enableDHCP {

    assertions = [ {
      # dhcpcd doesn't start properly with malloc ∉ [ libc scudo ]
      # see https://github.com/NixOS/nixpkgs/issues/151696
      assertion =
        dhcpcd.enablePrivSep
          -> elem config.environment.memoryAllocator.provider [ "libc" "scudo" ];
      message = ''
        dhcpcd with privilege separation is incompatible with chosen system malloc.
          Currently only the `libc` and `scudo` allocators are known to work.
          To disable dhcpcd's privilege separation, overlay Nixpkgs and override dhcpcd
          to set `enablePrivSep = false`.
      '';
    } ];

    systemd.services.dhcpcd = let
      cfgN = config.networking;
      hasDefaultGatewaySet = (cfgN.defaultGateway != null && cfgN.defaultGateway.address != "")
                          && (!cfgN.enableIPv6 || (cfgN.defaultGateway6 != null && cfgN.defaultGateway6.address != ""));
    in
      { description = "DHCP Client";

        wantedBy = [ "multi-user.target" ] ++ optional (!hasDefaultGatewaySet) "network-online.target";
        wants = [ "network.target" ];
        before = [ "network-online.target" ];

        restartTriggers = [ exitHook ];

        # Stopping dhcpcd during a reconfiguration is undesirable
        # because it brings down the network interfaces configured by
        # dhcpcd.  So do a "systemctl restart" instead.
        stopIfChanged = false;

        path = [ dhcpcd pkgs.nettools config.networking.resolvconf.package ];

        unitConfig.ConditionCapability = "CAP_NET_ADMIN";

        serviceConfig =
          { Type = "forking";
            PIDFile = "/run/dhcpcd/pid";
            RuntimeDirectory = "dhcpcd";
            ExecStart = "@${dhcpcd}/sbin/dhcpcd dhcpcd --quiet ${optionalString cfg.persistent "--persistent"} --config ${dhcpcdConf}";
            ExecReload = "${dhcpcd}/sbin/dhcpcd --rebind";
            Restart = "always";
          };
      };

    users.users.dhcpcd = {
      isSystemUser = true;
      group = "dhcpcd";
    };
    users.groups.dhcpcd = {};

    environment.systemPackages = [ dhcpcd ];

    environment.etc."dhcpcd.exit-hook".source = exitHook;

    powerManagement.resumeCommands = mkIf config.systemd.services.dhcpcd.enable
      ''
        # Tell dhcpcd to rebind its interfaces if it's running.
        /run/current-system/systemd/bin/systemctl reload dhcpcd.service
      '';

  };

}
