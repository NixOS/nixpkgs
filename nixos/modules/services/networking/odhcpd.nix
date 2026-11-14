{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.odhcpd;

  uciFormat = {
    type =
      let
        atom = lib.types.oneOf [
          lib.types.bool
          lib.types.int
          lib.types.path
          lib.types.str
        ];
      in
      lib.types.attrsOf (
        lib.types.attrsOf (lib.types.attrsOf (lib.types.either atom (lib.types.listOf atom)))
      )
      // {
        description = "UCI configuration (section type, then section name, then options)";
      };

    generate =
      name: value:
      let
        quote =
          v:
          lib.escapeShellArg (
            if lib.isBool v then
              (if v then "1" else "0")
            else if lib.isPath v then
              "${v}"
            else
              toString v
          );
        mkKeyValue =
          k: v:
          if lib.isList v then
            lib.concatMapStringsSep "\n\t" (x: "list ${k} ${quote x}") v
          else
            "option ${k} ${quote v}";
        toBody =
          options:
          lib.generators.toKeyValue {
            inherit mkKeyValue;
            indent = "\t";
          } (lib.filterAttrs (_: v: v != [ ]) options);
        mkSection =
          type: sectionName: options:
          "config ${type} ${quote sectionName}\n${toBody options}";
      in
      pkgs.writeText name (
        lib.concatStringsSep "\n" (
          lib.concatLists (lib.mapAttrsToList (type: lib.mapAttrsToList (mkSection type)) value)
        )
      );
  };

  configDir = pkgs.linkFarm "odhcpd-config" { dhcp = uciFormat.generate "odhcpd-dhcp" cfg.settings; };

  interfaces = lib.unique (
    lib.mapAttrsToList (_: section: section.ifname or section.networkid) (
      lib.filterAttrs (_: section: section ? ifname || section ? networkid) (cfg.settings.dhcp or { })
    )
  );
  devices = map (
    iface: "sys-subsystem-net-devices-${utils.escapeSystemdPath iface}.device"
  ) interfaces;
in
{
  options.services.odhcpd = {
    enable = lib.mkEnableOption "odhcpd, the OpenWrt DHCP, DHCPv6 and router advertisement server";

    package = lib.mkPackageOption pkgs "odhcpd" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to open UDP ports 67 (DHCPv4) and 547 (DHCPv6) in the firewall,
        on the interfaces named by the `ifname` (or `networkid`) of each `dhcp` section.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule { freeformType = uciFormat.type; };
      default = { };
      example = {
        dhcp.lan = {
          ifname = "br0";
          ra = "server";
          dhcpv4 = "disabled";
          dhcpv6 = "disabled";
          ra_flags = [ "none" ];
          dns = [ "fd00::53" ];
        };
      };
      description = ''
        odhcpd configuration, written to the {file}`dhcp` file in UCI format.
        See <https://github.com/openwrt/odhcpd#configuration> for the available options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    services.odhcpd.settings.odhcpd.odhcpd.piodir = lib.mkDefault "/var/lib/odhcpd";

    networking.firewall.interfaces = lib.mkIf cfg.openFirewall (
      lib.genAttrs interfaces (_: {
        allowedUDPPorts = [
          67
          547
        ];
      })
    );

    systemd.services.odhcpd = {
      description = "odhcpd DHCP, DHCPv6 and router advertisement server";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ devices;
      bindsTo = devices;

      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package} -c ${configDir} -f";
        Restart = "on-failure";

        DynamicUser = true;
        StateDirectory = "odhcpd";
        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
          "CAP_NET_RAW"
        ];

        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_PACKET"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ savyajha ];
}
