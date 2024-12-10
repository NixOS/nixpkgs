# This module automatically discovers zones in BIND and NSD NixOS
# configurations and creates zones for all definitions of networking.extraHosts
# (except those that point to 127.0.0.1 or ::1) within the current test network
# and delegates these zones using a fake root zone served by a BIND recursive
# name server.
{
  config,
  nodes,
  pkgs,
  lib,
  ...
}:

{
  options.test-support.resolver.enable = lib.mkOption {
    type = lib.types.bool;
    default = true;
    internal = true;
    description = ''
      Whether to enable the resolver that automatically discovers zone in the
      test network.

      This option is `true` by default, because the module
      defining this option needs to be explicitly imported.

      The reason this option exists is for the
      {file}`nixos/tests/common/acme/server` module, which
      needs that option to disable the resolver once the user has set its own
      resolver.
    '';
  };

  config = lib.mkIf config.test-support.resolver.enable {
    networking.firewall.enable = false;
    services.bind.enable = true;
    services.bind.cacheNetworks = lib.mkForce [ "any" ];
    services.bind.forwarders = lib.mkForce [ ];
    services.bind.zones = lib.singleton {
      name = ".";
      file =
        let
          addDot = zone: zone + lib.optionalString (!lib.hasSuffix "." zone) ".";
          mkNsdZoneNames = zones: map addDot (lib.attrNames zones);
          mkBindZoneNames = zones: map (zone: addDot zone.name) zones;
          getZones = cfg: mkNsdZoneNames cfg.services.nsd.zones ++ mkBindZoneNames cfg.services.bind.zones;

          getZonesForNode = attrs: {
            ip = attrs.config.networking.primaryIPAddress;
            zones = lib.filter (zone: zone != ".") (getZones attrs.config);
          };

          zoneInfo = lib.mapAttrsToList (lib.const getZonesForNode) nodes;

          # A and AAAA resource records for all the definitions of
          # networking.extraHosts except those for 127.0.0.1 or ::1.
          #
          # The result is an attribute set with keys being the host name and the
          # values are either { ipv4 = ADDR; } or { ipv6 = ADDR; } where ADDR is
          # the IP address for the corresponding key.
          recordsFromExtraHosts =
            let
              getHostsForNode = lib.const (n: n.config.networking.extraHosts);
              allHostsList = lib.mapAttrsToList getHostsForNode nodes;
              allHosts = lib.concatStringsSep "\n" allHostsList;

              reIp = "[a-fA-F0-9.:]+";
              reHost = "[a-zA-Z0-9.-]+";

              matchAliases =
                str:
                let
                  matched = builtins.match "[ \t]+(${reHost})(.*)" str;
                  continue = lib.singleton (lib.head matched) ++ matchAliases (lib.last matched);
                in
                lib.optional (matched != null) continue;

              matchLine =
                str:
                let
                  result = builtins.match "[ \t]*(${reIp})[ \t]+(${reHost})(.*)" str;
                in
                if result == null then
                  null
                else
                  {
                    ipAddr = lib.head result;
                    hosts = lib.singleton (lib.elemAt result 1) ++ matchAliases (lib.last result);
                  };

              skipLine =
                str:
                let
                  rest = builtins.match "[^\n]*\n(.*)" str;
                in
                if rest == null then "" else lib.head rest;

              getEntries =
                str: acc:
                let
                  result = matchLine str;
                  next = getEntries (skipLine str);
                  newEntry = acc ++ lib.singleton result;
                  continue = if result == null then next acc else next newEntry;
                in
                if str == "" then acc else continue;

              isIPv6 = str: builtins.match ".*:.*" str != null;
              loopbackIps = [
                "127.0.0.1"
                "::1"
              ];
              filterLoopback = lib.filter (e: !lib.elem e.ipAddr loopbackIps);

              allEntries = lib.concatMap (
                entry:
                map (host: {
                  inherit host;
                  ${if isIPv6 entry.ipAddr then "ipv6" else "ipv4"} = entry.ipAddr;
                }) entry.hosts
              ) (filterLoopback (getEntries (allHosts + "\n") [ ]));

              mkRecords =
                entry:
                let
                  records =
                    lib.optional (entry ? ipv6) "AAAA ${entry.ipv6}"
                    ++ lib.optional (entry ? ipv4) "A ${entry.ipv4}";
                  mkRecord = typeAndData: "${entry.host}. IN ${typeAndData}";
                in
                lib.concatMapStringsSep "\n" mkRecord records;

            in
            lib.concatMapStringsSep "\n" mkRecords allEntries;

          # All of the zones that are subdomains of existing zones.
          # For example if there is only "example.com" the following zones would
          # be 'subZones':
          #
          #  * foo.example.com.
          #  * bar.example.com.
          #
          # While the following would *not* be 'subZones':
          #
          #  * example.com.
          #  * com.
          #
          subZones =
            let
              allZones = lib.concatMap (zi: zi.zones) zoneInfo;
              isSubZoneOf = z1: z2: lib.hasSuffix z2 z1 && z1 != z2;
            in
            lib.filter (z: lib.any (isSubZoneOf z) allZones) allZones;

          # All the zones without 'subZones'.
          filteredZoneInfo = map (
            zi:
            zi
            // {
              zones = lib.filter (x: !lib.elem x subZones) zi.zones;
            }
          ) zoneInfo;

        in
        pkgs.writeText "fake-root.zone" ''
          $TTL 3600
          . IN SOA ns.fakedns. admin.fakedns. ( 1 3h 1h 1w 1d )
          ns.fakedns. IN A ${config.networking.primaryIPAddress}
          . IN NS ns.fakedns.
          ${lib.concatImapStrings (
            num:
            { ip, zones }:
            ''
              ns${toString num}.fakedns. IN A ${ip}
              ${lib.concatMapStrings (zone: ''
                ${zone} IN NS ns${toString num}.fakedns.
              '') zones}
            ''
          ) (lib.filter (zi: zi.zones != [ ]) filteredZoneInfo)}
          ${recordsFromExtraHosts}
        '';
    };
  };
}
