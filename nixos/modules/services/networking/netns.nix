{
  pkgs,
  lib,
  config,
  options,
  ...
}:
with lib;
let
  cfg = config.services.netns;
  inherit (config) networking;
  # Escape as required by: https://www.freedesktop.org/software/systemd/man/systemd.unit.html
  escapeUnitName =
    name:
    lib.concatMapStrings (s: if lib.isList s then "-" else s) (
      builtins.split "[^a-zA-Z0-9_.\\-]+" name
    );
in
{
  options.services.netns = {
    namespaces = mkOption {
      description = ''
        Network namespaces to create.

        Other services can join a network namespace named `netns` with:
        ```
        PrivateNetwork=true;
        JoinsNamespaceOf="netns-''${netns}.service";
        ```

        So can `iproute2` with: `ip -n ''${netns}`

        ::: {.warning}
        You should usually create (or update via your VPN configuration's up script)
        a file named `/etc/netns/''${netns}/resolv.conf`
        that will be bind-mounted by `ip -n ''${netns}` onto `/etc/resolv.conf`,
        which you'll also want to configure in the services joining this network namespace:
        ```
        BindReadOnlyPaths = ["/etc/netns/''${netns}/resolv.conf:/etc/resolv.conf"];
        ```
        :::
      '';
      default = { };
      type = types.attrsOf (
        types.submodule {
          options.nftables = mkOption {
            description = "Nftables ruleset within the network namespace.";
            type = types.lines;
            default = networking.nftables.ruleset;
            defaultText = "config.networking.nftables.ruleset";
          };
          options.sysctl = options.boot.kernel.sysctl // {
            description = "sysctl within the network namespace.";
            default = config.boot.kernel.sysctl;
            defaultText = literalMD "config.boot.kernel.sysctl";
          };
          options.service = mkOption {
            description = "Systemd configuration specific to this netns service";
            type = types.attrs;
            default = { };
          };
        }
      );
    };
  };
  config = {
    systemd.services = mapAttrs' (
      name: c:
      nameValuePair "netns-${escapeUnitName name}" (mkMerge [
        {
          description = "${name} network namespace";
          before = [ "network.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            # Let systemd create the netns so that PrivateNetwork=true
            # with JoinsNamespaceOf="netns-${name}.service" works.
            PrivateNetwork = true;
            # PrivateNetwork=true implies PrivateMounts=true by default,
            # which would prevent the persisting and sharing of /var/run/netns/$name
            # causing `ip netns exec $name $SHELL` outside of this service to fail with:
            # Error: Peer netns reference is invalid.
            # As `stat -f -c %T /var/run/netns/$name` would not be "nsfs" in those mntns.
            # See https://serverfault.com/questions/961504/cannot-create-nested-network-namespace
            PrivateMounts = false;
            ExecStart =
              [
                # Register the netns with a binding mount to /var/run/netns/$name to keep it alive,
                # and make sure resolv.conf can be used in BindReadOnlyPaths=
                # For propagating changes in that file to the services bind mounting it,
                # updating must not remove the file, but only truncate it.
                (pkgs.writeShellScript "ip-netns-attach" ''
                  ${pkgs.iproute2}/bin/ip netns attach ${escapeShellArg name} $$
                  mkdir -p /etc/netns/${escapeShellArg name}
                  touch /etc/netns/${escapeShellArg name}/resolv.conf
                '')

                # Bringing the loopback interface is almost always a good thing.
                "${pkgs.iproute2}/bin/ip link set dev lo up"

                # Use --ignore because some keys may no longer exist in that new namespace,
                # like net.ipv6.conf.eth0.addr_gen_mode or net.core.rmem_max
                ''
                  ${pkgs.procps}/bin/sysctl --ignore -p ${
                    pkgs.writeScript "sysctl" (
                      concatStrings (
                        mapAttrsToList (
                          n: v: optionalString (v != null) "${n}=${if v == false then "0" else toString v}\n"
                        ) c.sysctl
                      )
                    )
                  }
                ''
              ]
              ++
              # Load the nftables ruleset of this netns.
              optional networking.nftables.enable (
                pkgs.writeScript "nftables-ruleset" ''
                  #!${pkgs.nftables}/bin/nft -f
                  flush ruleset
                  ${c.nftables}
                ''
              );
            # Unregister the netns from the tracking mecanism of iproute2.
            ExecStop = "${pkgs.iproute2}/bin/ip netns delete ${escapeShellArg name}";
          };
        }
        c.service
      ])
    ) cfg.namespaces;
    meta.maintainers = with lib.maintainers; [ julm ];
  };
}
