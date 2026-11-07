# OVN {#module-services-ovn}

[OVN](https://www.ovn.org/) builds logical switches and routers on top of
Open vSwitch. A central control plane stores the logical topology and turns it
into per-chassis instructions. An `ovn-controller` on each chassis then
programs its local Open vSwitch datapath.

The NixOS module models each OVN component independently:

- `services.ovn.northbound` runs the northbound database.
- `services.ovn.southbound` runs the southbound database.
- `services.ovn.relay` serves chassis connections through a relay of the local
  southbound database, with its own TLS credentials and trust store.
- `services.ovn.northd` translates the northbound topology into southbound
  instructions.
- `services.ovn.controller` runs one or more chassis controllers against the
  host's Open vSwitch database.

This separation is useful because central databases normally run on a small
set of control-plane nodes, while controllers run wherever workloads attach to
logical networks. The module supports standalone and Raft central databases
and colocated southbound relays. Remote relay sources and OVN interconnection
are not modeled.

## Standalone control plane {#module-services-ovn-standalone}

The smallest deployment runs both databases and `ovn-northd` on one host.
They communicate through local Unix sockets, so this deployment does not need
network listeners or firewall changes.

```nix
{
  services.ovn = {
    northbound.enable = true;
    southbound.enable = true;
    northd.enable = true;
  };
}
```

## Network access and trust {#module-services-ovn-network}

Network listeners and Raft connections use TLS by default and require `tls`
credentials. The transport is called `ssl` in OVSDB connection strings.
Ports remain closed in the NixOS firewall unless explicitly opened with
`listeners.<name>.openFirewall` or `raft.openFirewall`.

Southbound listeners use OVN's restricted `ovn-controller` RBAC role by
default. RBAC identifies each controller by its client certificate's common
name, which must match `chassisName`. Administrative clients and `ovn-northd`
need unrestricted access, selected by `role = null` on a southbound listener.

All listeners in one database server share its TLS trust store. Different
client certificates do not isolate their privileges: a controller whose
certificate is trusted by an unrestricted endpoint can connect there and
bypass RBAC. The module therefore rejects restricted and unrestricted
network listeners in the same server.

To serve both kinds of client, enable `services.ovn.relay` alongside the
southbound database. The relay connects to the database's local Unix socket
and provides restricted network access for controllers. Put unrestricted
network listeners on the database itself. Local administrative access remains
available through the database's Unix socket, protected by filesystem
permissions.

Provision independent CAs for the two trust domains:

- The control-plane CA signs database, `ovn-northd`, and administrative client
  certificates. Database listeners and Raft connections use this trust store.
- The chassis CA signs relay and controller certificates. Only the relay
  trusts chassis clients; the databases must not trust this CA or a shared
  root that would also authenticate chassis certificates.

The module does not verify CA separation. Different certificate files, leaf
certificates, or intermediate CAs alone do not establish this boundary if the
database still trusts chassis certificates.

Provision TLS files outside the Nix store, make them readable by the `ovn`
user, and restrict access to private keys. The module does not generate or
distribute certificates.

Listener attribute names such as `main`, `controller`, and `administration`
are arbitrary Nix-side identifiers. The values define the actual address,
port, transport, and RBAC role.

For example, a remote `ovn-northd` can connect to independent northbound and
southbound clusters:

```nix
{
  services.ovn.northd = {
    enable = true;
    northbound = "ssl:nb1:6641,ssl:nb2:6641,ssl:nb3:6641";
    southbound = "ssl:sb1:16642,ssl:sb2:16642,ssl:sb3:16642";
    tls = {
      privateKey = "/run/credentials/ovn/northd.key";
      certificate = "/run/credentials/ovn/northd.crt";
      caCertificate = "/run/credentials/ovn/control-plane-ca.crt";
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
let
  controlPlaneTls = {
    privateKey = "/run/credentials/ovn/control-plane.key";
    certificate = "/run/credentials/ovn/control-plane.crt";
    caCertificate = "/run/credentials/ovn/control-plane-ca.crt";
  };
  chassisTls = {
    privateKey = "/run/credentials/ovn/relay.key";
    certificate = "/run/credentials/ovn/relay.crt";
    caCertificate = "/run/credentials/ovn/chassis-ca.crt";
  };
  raft = {
    localAddress = "192.0.2.12";
    openFirewall = true;
    bootstrap = {
      mode = "join";
      address = "192.0.2.11";
    };
  };
in
{
  services.ovn = {
    northbound = {
      enable = true;
      mode = "raft";
      inherit raft;
      tls = controlPlaneTls;
      listeners.northd.openFirewall = true;
    };

    southbound = {
      enable = true;
      mode = "raft";
      inherit raft;
      tls = controlPlaneTls;
      listeners.northd = {
        port = 16642;
        role = null;
        openFirewall = true;
      };
    };

    relay = {
      enable = true;
      tls = chassisTls;
      listeners.controllers.openFirewall = true;
    };

    northd = {
      enable = true;
      tls = controlPlaneTls;
      northbound = "ssl:192.0.2.11:6641,ssl:192.0.2.12:6641,ssl:192.0.2.13:6641";
      southbound = "ssl:192.0.2.11:16642,ssl:192.0.2.12:16642,ssl:192.0.2.13:16642";
    };
  };
}
```

Configure `bootstrap.mode = "create"` and omit `address` on the first
member. A three-node cluster can lose one member while retaining quorum; place
the members on independent failure domains. Each member uses its own
control-plane and relay certificates, signed by the respective CAs. Raft
traffic uses the database's `tls` credentials.

Give `ovn-northd` all database endpoints so it can reconnect when a member is
unavailable or no longer the leader. This is needed even when `ovn-northd`
runs on a database node: the northbound and southbound leaders may be on
different hosts. Give controllers all relay endpoints, on port 6642 in this
example. Each relay follows its local southbound database and reconnects if
that database restarts.

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
        caCertificate = "/run/credentials/ovn/chassis-ca.crt";
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
