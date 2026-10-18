# OVN {#module-services-ovn}

[OVN](https://www.ovn.org/) builds logical switches and routers on top of
Open vSwitch. A central control plane stores the logical topology and turns it
into per-chassis instructions. An `ovn-controller` on each chassis then
programs its local Open vSwitch datapath.

The NixOS module models each OVN component independently:

- `services.ovn.northbound` runs the northbound database.
- `services.ovn.southbound` runs the southbound database.
- `services.ovn.northd` translates the northbound topology into southbound
  instructions.
- `services.ovn.controller` runs one or more chassis controllers against the
  host's Open vSwitch database.

This separation is useful because central databases normally run on a small
set of control-plane nodes, while controllers run wherever workloads attach to
logical networks. The first version of this module supports standalone and
Raft central databases. OVN interconnection and southbound relay services are
not yet modeled.

## Standalone control plane {#module-services-ovn-standalone}

The smallest deployment runs both databases and `ovn-northd` on one host. The
southbound controller listener uses OVN's restricted `ovn-controller` RBAC
role by default. RBAC requires TLS because it identifies each controller by
the common name in its client certificate. Administrative clients and a
remote `ovn-northd` need a separate unrestricted listener.

Listener attribute names such as `main`, `controller`, and `administration`
are arbitrary Nix-side identifiers. The values define the actual address,
port, transport, and RBAC role. The examples spell these values out to
make the exposed sockets and their security properties explicit.

```nix
{
  services.ovn = {
    northbound = {
      enable = true;
      openFirewall = true;
      listeners.main = {
        address = "0.0.0.0";
        port = 6641;
        transport = "tcp";
      };
    };

    southbound = {
      enable = true;
      openFirewall = true;
      tls = {
        privateKey = "/run/credentials/ovn/server.key";
        certificate = "/run/credentials/ovn/server.crt";
        caCertificate = "/run/credentials/ovn/ca.crt";
      };
      listeners = {
        controller = {
          address = "0.0.0.0";
          port = 6642;
          transport = "ssl";
          role = "ovn-controller";
        };
        administration = {
          address = "0.0.0.0";
          port = 16642;
          transport = "ssl";
          role = null;
        };
      };
    };

    northd.enable = true;
  };
}
```

The local Unix sockets remain available even when no network listeners are
configured.

The components need not share a host. A remote `ovn-northd` can connect to
independent northbound and southbound clusters:

```nix
{
  services.ovn.northd = {
    enable = true;
    northbound = "ssl:nb1:6641,ssl:nb2:6641,ssl:nb3:6641";
    southbound = "ssl:sb1:16642,ssl:sb2:16642,ssl:sb3:16642";
    tls = {
      privateKey = "/run/credentials/ovn/northd.key";
      certificate = "/run/credentials/ovn/northd.crt";
      caCertificate = "/run/credentials/ovn/ca.crt";
    };
  };
}
```

Multiple `ovn-northd` instances connected to the same databases automatically
operate as one active instance and hot standbys. Southbound listeners used by
`ovn-northd` must grant unrestricted access.

## Raft control plane {#module-services-ovn-raft}

For high availability, configure both databases as Raft members. Exactly one
node creates each new cluster; the other nodes join it. Bootstrap settings are
only used when the local database does not yet exist.

```nix
{
  services.ovn = {
    northbound = {
      enable = true;
      openFirewall = true;
      mode = "raft";
      listeners.main = {
        address = "0.0.0.0";
        port = 6641;
        transport = "tcp";
      };
      raft = {
        localAddress = "192.0.2.12";
        bootstrap = {
          mode = "join";
          address = "192.0.2.11";
        };
      };
    };

    southbound = {
      enable = true;
      openFirewall = true;
      mode = "raft";
      listeners = {
        controller = {
          address = "0.0.0.0";
          port = 6642;
          transport = "ssl";
          role = "ovn-controller";
        };
        administration = {
          address = "0.0.0.0";
          port = 16642;
          transport = "ssl";
          role = null;
        };
      };
      tls = {
        privateKey = "/run/credentials/ovn/server.key";
        certificate = "/run/credentials/ovn/server.crt";
        caCertificate = "/run/credentials/ovn/ca.crt";
      };
      raft = {
        localAddress = "192.0.2.12";
        bootstrap = {
          mode = "join";
          address = "192.0.2.11";
        };
      };
    };

    northd = {
      enable = true;
      northbound = "tcp:192.0.2.11:6641,tcp:192.0.2.12:6641,tcp:192.0.2.13:6641";
      southbound = "ssl:192.0.2.11:16642,ssl:192.0.2.12:16642,ssl:192.0.2.13:16642";
      tls = {
        privateKey = "/run/credentials/ovn/server.key";
        certificate = "/run/credentials/ovn/server.crt";
        caCertificate = "/run/credentials/ovn/ca.crt";
      };
    };
  };
}
```

Configure `bootstrap.mode = "create"` and omit `address` on the first
member. A three-node cluster can lose one member while retaining quorum; place
the members on independent failure domains. Set `raft.transport = "ssl"` to
encrypt cluster traffic using the database's `tls` credentials. Give clients
all database endpoints, as shown for `ovn-northd`, so they can reconnect when
a member is unavailable or no longer the leader.

Raft membership is persistent cluster state and is not derived from enabled
NixOS services. Disabling a database service does not remove its member. For a
planned removal, run `cluster/leave` through `ovn-appctl` for both databases
before disabling them; use `cluster/kick` from a healthy member if the old
member is unavailable. A removed member must be initialized again before it
can rejoin.

## Chassis controllers {#module-services-ovn-controller}

Controller settings use the names documented by `ovn-controller(8)`. The
module writes them to the local `Open_vSwitch.external_ids` map and appends the
chassis name, which is OVN's convention for running multiple controllers
against one Open vSwitch database.

```nix
{
  services.ovn.controller = {
    enable = true;
    openFirewall = true;

    settings = {
      "ovn-remote-probe-interval" = "5000";
    };

    instances.default = {
      chassisName = "compute-1";
      encapsulation = {
        ips = [ "192.0.2.21" ];
      };
      settings = {
        "ovn-remote" = "ssl:192.0.2.11:6642,ssl:192.0.2.12:6642,ssl:192.0.2.13:6642";
        "ovn-bridge" = "br-int";
        "ovn-bridge-mappings" = "provider:br-provider";
      };
      tls = {
        privateKey = "/run/credentials/ovn/compute-1.key";
        certificate = "/run/credentials/ovn/compute-1.crt";
        caCertificate = "/run/credentials/ovn/ca.crt";
      };
    };
  };
}
```

Controller-level `settings` are host-global OVN defaults. The OVN module
contributes them to `virtualisation.vswitch.externalIds`, and the Open vSwitch
module writes the merged declarations to its `Open_vSwitch.external_ids` map.
Entries not declared through that option are left unchanged.

`openFirewall` opens the standard UDP port for every configured Geneve or
VXLAN encapsulation type. Tunnel ports customized through the southbound
database must be opened separately.

Each instance's `encapsulation` is rendered to the corresponding
`ovn-encap-type` and `ovn-encap-ip` external IDs. These two keys therefore
cannot also be declared through `settings`.

Instance `settings` are different: they are per-controller external IDs. The
module appends the instance's chassis name to each key before writing it. A
global external ID and a generated per-controller external ID may not resolve
to the same key.

`ovn-bridge-mappings` maps OVN physical-network names to Open vSwitch bridges;
the bridges and their physical ports still need to be created separately.

When several controllers share a host, give every instance a unique chassis
name and integration bridge. Stateful deployments must also give them
non-overlapping `ct-zone-range` values:

```nix
{
  services.ovn.controller.instances = {
    blue = {
      chassisName = "compute-1-blue";
      settings = {
        "ovn-bridge" = "br-int-blue";
        "ct-zone-range" = "1-30000";
      };
    };
    red = {
      chassisName = "compute-1-red";
      settings = {
        "ovn-bridge" = "br-int-red";
        "ct-zone-range" = "30001-60000";
      };
    };
  };
}
```

The shortened example omits the remote, encapsulation, and TLS settings that
each instance normally also needs.
