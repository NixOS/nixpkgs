testModuleArgs@{
  lib,
  ...
}:

let
  inherit (lib)
    attrNames
    concatMapAttrsStringSep
    concatMapStrings
    forEach
    head
    listToAttrs
    mkDefault
    mkOption
    nameValuePair
    optionalString
    range
    toLower
    types
    zipListsWith
    zipLists
    ;

  nodeNumbers = listToAttrs (
    zipListsWith nameValuePair (attrNames testModuleArgs.config.allMachines) (range 1 254)
  );

  networkModule =
    { config, ... }:
    let
      interfaces = lib.attrValues config.virtualisation.allInterfaces;

      # Automatically assign IP addresses to requested interfaces.
      assignIPs = lib.filter (i: i.assignIP) interfaces;
      ipInterfaces = forEach assignIPs (
        i:
        nameValuePair i.name {
          ipv4.addresses = [
            {
              address = "192.168.${toString i.vlan}.${toString config.virtualisation.test.nodeNumber}";
              prefixLength = 24;
            }
          ];
          ipv6.addresses = [
            {
              address = "2001:db8:${toString i.vlan}::${toString config.virtualisation.test.nodeNumber}";
              prefixLength = 64;
            }
          ];
        }
      );

      networkConfig = {
        networking.hostName = mkDefault config.virtualisation.test.nodeName;

        networking.interfaces = listToAttrs ipInterfaces;

        networking.primaryIPAddress =
          optionalString (ipInterfaces != [ ])
            (head (head ipInterfaces).value.ipv4.addresses).address;

        networking.primaryIPv6Address =
          optionalString (ipInterfaces != [ ])
            (head (head ipInterfaces).value.ipv6.addresses).address;

        # Generate /etc/hosts including every remote's primary IP addresses
        # (whichever VLAN they may belong to) as well as all IP addresses from
        # VLANs that both the local machine and the remote machine share.
        networking.extraHosts =
          let
            localVlans = config.virtualisation.vlans;
          in
          concatMapAttrsStringSep "" (
            mName: remoteConfig:
            let
              remoteInterfaces = remoteConfig.networking.interfaces;
              sharedIps = lib.flatten (
                lib.mapAttrsToList (
                  ifaceName: ifaceCfg:
                  let
                    remoteIfaceMeta = remoteConfig.virtualisation.allInterfaces."${ifaceName}" or { };
                    vlanId = remoteIfaceMeta.vlan or null;
                  in
                  if vlanId != null && builtins.elem vlanId localVlans then
                    map (addr: addr.address) ifaceCfg.ipv4.addresses ++ map (addr: addr.address) ifaceCfg.ipv6.addresses
                  else
                    [ ]
                ) remoteInterfaces
              );

              # We also want to test router protocols that enable connections
              # between nodes even if they don't share a VLAN, so we include
              # the primary IPs of all machines in the hosts file.
              primaryIPs = [
                remoteConfig.networking.primaryIPAddress
                remoteConfig.networking.primaryIPv6Address
              ];

              allReachableIps = lib.lists.uniqueStrings (sharedIps ++ primaryIPs);

              hostnames =
                optionalString (
                  remoteConfig.networking.domain != null
                ) "${remoteConfig.networking.hostName}.${remoteConfig.networking.domain} "
                + "${remoteConfig.networking.hostName}\n";
            in
            builtins.concatStringsSep "" (map (ip: "${ip} ${hostnames}") allReachableIps)
          ) testModuleArgs.config.allMachines;
      };
    in
    {
      key = "network-interfaces";
      config = networkConfig // {
        # Expose the networkConfig items for tests like nixops
        # that need to recreate the network config.
        system.build.networkConfig = networkConfig;
      };
    };

  qemuNetworkModule =
    { config, pkgs, ... }:
    let
      qemu-common = import ../qemu-common.nix { inherit (pkgs) lib stdenv; };

      interfaces = lib.attrValues config.virtualisation.allInterfaces;

      interfacesNumbered = zipLists interfaces (range 1 255);

      qemuOptions = lib.flatten (
        forEach interfacesNumbered (
          { fst, snd }: qemu-common.qemuNICFlags snd fst.vlan config.virtualisation.test.nodeNumber
        )
      );
      udevRules = map (
        interface:
        # MAC Addresses for QEMU network devices are lowercase, and udev string comparison is case-sensitive.
        ''SUBSYSTEM=="net",ACTION=="add",ATTR{address}=="${toLower (qemu-common.qemuNicMac interface.vlan config.virtualisation.test.nodeNumber)}",NAME="${interface.name}"''
      ) interfaces;
    in
    {
      virtualisation.qemu.options = qemuOptions;
      boot.initrd.services.udev.rules = concatMapStrings (x: x + "\n") udevRules;
    };

  nodeNumberModule = (
    regular@{ config, name, ... }:
    {
      options = {
        virtualisation.test.nodeName = mkOption {
          internal = true;
          default = name;
          # We need to force this in specialisations, otherwise it'd be
          # readOnly = true;
          description = ''
            The `name` in `nodes.<name>` and `containers.<name>`; stable across `specialisations`.
          '';
        };
        virtualisation.test.nodeNumber = mkOption {
          internal = true;
          type = types.int;
          readOnly = true;
          default = nodeNumbers.${config.virtualisation.test.nodeName};
          description = ''
            A unique number assigned for each machine in `nodes` and `containers`.
          '';
        };

        # specialisations override the `name` module argument,
        # so we push the real `virtualisation.test.nodeName`.
        specialisation = mkOption {
          type = types.attrsOf (
            types.submodule {
              options.configuration = mkOption {
                type = types.submoduleWith {
                  modules = [
                    {
                      config.virtualisation.test.nodeName =
                        # assert regular.config.virtualisation.test.nodeName != "configuration";
                        regular.config.virtualisation.test.nodeName;
                    }
                  ];
                };
              };
            }
          );
        };
      };
    }
  );

in
{
  config = {
    extraBaseModules = {
      imports = [
        networkModule
        nodeNumberModule
      ];
    };
    extraBaseNodeModules = {
      imports = [
        qemuNetworkModule
      ];
    };
  };
}
