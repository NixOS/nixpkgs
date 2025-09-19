# Ceph {#module-services-ceph}

Ceph is a distributed object, block, and file storage platform.

::: {.note}
A short word on *cephadm*: while using *cephadm* makes provisioning and managing a Ceph cluster a lot easier for most users, using it with NixOS is more complex and involved since {file}`/etc/systemd` is not freely writable and commands like `systemctl enable` are disabled on NixOS.
Several solutions exist, all of which have their own advantages and disadvantages:

- running *rook* in *kubernetes*
- running the raw *ceph* OCI images via NixOS
- instantiating a container bootstrapped with a different distro (and passing through the devices)
- convincing *cephadm* to use {file}`/lib/systemd` as the systemd configuration location (as it is unused by NixOS)

Any and all of these are out of scope for this documentation, however they deserve to be mentioned nonetheless.
:::

## Installation {#module-services-ceph-installation}

NixOS provides configuration for running Ceph daemons and providing configuration via {file}`/etc/ceph/ceph.conf`.
Credential management for both clients and the daemons themselves, as well as the bootstrap process are not part of the NixOS module.

For deploying a cluster the outline provided by the [upstream Ceph documentation for manual deployment](https://docs.ceph.com/en/latest/install/manual-deployment/) should be followed.
Individual steps, such as changing a configuration file or starting a daemon, may differ from what is provided by NixOS, and this section will walk you through the differences.

::: {.warning}
When referencing Ceph documentation take note to switch to the correct version for your deployment (latest being the current in-development version).
Trying to apply a newer documentation to an older cluster version or vice versa may yield undesirable results.
:::

The first step of generating the UUID for the cluster (the *fsid*) remain the same, however it should be provided to both clients and cluster nodes via {option}`services.ceph.global.fsid`.
Similarly the `mon_initial_members` and their IP addresses should be provided as follows:

- the list of all monitors *by name* should be stored in {option}`services.ceph.global.monInitialMembers` as a comma separated list
- each monitor should receive its own section in the config via {option}`services.ceph.client.extraConfig`
  - the name being the same as in `monInitialMembers` but with a `mon.` prefix, e.g. {option}`services.ceph.client.extraConfig."mon.0"` (quotes due to Nix syntax)
  - the value of that key should include its `mon_addr`, `public_addr`, and `cluster_addr` (the latter can be omitted if there is no separete cluster network)
  - multiple addresses may be provided, however care should be taken to only provide one address per msgr version (the version of the network protocol)
  - additional options such as crush location information may be of use, but are not strictly required, please consult [the monitor configuration reference](https://docs.ceph.com/en/latest/rados/configuration/mon-config-ref/#configuring-monitors)

::: {.warning}
Clusters should be deployed single-stack (either IPv6 *or* IPv4).
While Ceph itself can operate in dual-stack [not all client implementations gracefully support multiple IP addresses](https://github.com/torvalds/linux/blob/75b607fab38d149f232f01eae5e6392b394dd659/net/ceph/decode.c#L124-L128).
Therefore it is important that daemons be configured to listen on the correct address family when multiple address families are present on the node.
The family can be changed later on but may require a full cluster reboot to avoid confusing or crashing non-compliant clients during the change.
:::

Assuming only the Messenger v2 protocol is used, and three mons are provided on separete IPs with the same port, the base configuration may look similar to this (the `ms_bind_*` directives are for IPv6 here, and can be flipped for an IPv4 deployment):

```nix
{
  services.ceph = {
    enable = true;
    global = {
      fsid = "c9dx8da0-c6xe-46x6-b7x4-c33af1af3x86";
      monInitialMembers = "0,1,2";
      # other options such as publicNetwork or clusterNetwork are also available
    };
    extraConfig = {
      ms_bind_ipv4 = "false";
      ms_bind_ipv6 = "true";
      # please consult the upstream documentation for further options here
      # the NixOS Tests may provide a baseline of known-good settings too
    };
    client = {
      enable = true;
      extraConfig = {
        "mon.0" = { mon_addr = "v2:[2001:db8::1:0]:3300"; };
        "mon.1" = { mon_addr = "v2:[2001:db8::1:1]:3300"; };
        "mon.2" = { mon_addr = "v2:[2001:db8::1:2]:3300"; };
      };
    };
  };
}
```

Note that this setup is the same as when using NixOS purely as a Ceph client (save for the `ms_bind_*` options).

Applying this configuration will provide you with the configuration in {file}`/etc/ceph/ceph.conf` required to deploy the actual daemons.
With the configuration file in place the *ceph-authtool* commands to generate the Ceph admin keyring as well as the monitor, osd-bootstrap, and other keyrings and the *monmaptool* command to create the monitor database can be followed as per upstream documentation.
It may be simpler to only put only one monitor in the configuration however such that no quorum is required for the cluster to become available.
With only one monitor added to the monitor map and configuration that monitor will function as the cluster and additional monitors can be added dynamically via Ceph tooling (e.g. `ceph mon add`) and then later included in the configuration.

As soon as a monitor is initialized (after the `ceph-mon --mkfs` command) it can be started by adding it to the NixOS configuration using {option}`services.ceph.mon.daemons`:

```nix
{
  services.ceph = {
    # the above configuration should still be here
    mon = {
      enable = true;
      daemons = [ "0" ];
    };
  };
}
```

This will start *mon.0* on the host this configuration snipped is deployed to, which in a multi-node setup means that each cluster node should only list the daemons running on that specific host.
If *mon.1* and *mon.2* run on the same host (a single-node cluster) then the `daemons` line above should be `[ "0" "1" "2" ]`, however deploying the monitors of a distributed storage system onto separate nodes (read: distributing the monitors across the cluster) is advisable.

When this snipped is deployed the monitor(s) should be up and running and running `ceph -s` should succeed, albeit that there may be health warnings or errors which need attiontion, however those are out of scope for this documentation.

The upstream administrators guide can be followed for setting up MGR and MDS credentials just the same.

OSD instances behave mostly the same, although if Bluestore is used there may be extra requirements to have the LVM volumes activated on service start.

::: {.warning}
Ceph's *filestore* has been [declared unsupported since Reef (infobox at the top)](https://docs.ceph.com/en/squid/rados/configuration/filestore-config-ref/) and Ceph's upstream documentation recommends migrating to Bluestore.
:::

Specifically OSDs using the *dmcrypt* feature (effectively a LUKS layer between the LV and the OSD process) will require activation after every boot.
For OSDs without this feature it may be enough to activate the OSD once *without* the *tmpfs* flag of *ceph-volume* enabled, which will create the directory structure in {file}`/var/lib/ceph` for the daemon.
As long as the LVM LVs are activated automatically on boot (this is likely the default in most NixOS setups anyway) the OSD should find all its data and proceed to run accordingly.
For the LUKS portion it may be necessary to override the following options for a theoretical *osd.0*:

```nix
{
  # please note that there are several references to the osd id (0) which need to be changed for subsequent daemons
  # a more elaborate version of this can be found in nixos/tests/ceph-single-node-bluestore-dmcrypt.nix
  systemd.services.ceph-osd-0 = {
    path = with pkgs; [ util-linux lvm2 cryptsetup ]; # making sure tooling is present
    unitConfig.ConditionPathExists = lib.mkForce []; # the corresponding path may not exist as it is created by the ExecStartPre below
    serviceConfig = {
      ExecStartPre = lib.mkForce [
        # activate the volume (including cryptsetup)
        "!${config.services.ceph.osd.package.out}/bin/ceph-volume lvm activate --bluestore 0 THE-FSID-OF-THE-OSD-GOES-HERE --no-systemd"
        # some checks provided by NixOS by default that we do not want to remove
        "${config.services.ceph.osd.package.lib}/libexec/ceph/ceph-osd-prestart.sh --id 0 --cluster ${config.services.ceph.global.clusterName}"
      ];
      ExecStartPost = [
        # not strictly necessary, but more clean
        "!${config.services.ceph.osd.package.out}/bin/ceph-volume lvm deactivate 0"
      ];
    };
  };
}
```

With the keyrings created as per the upstream documentation, the OSD daemons added to {option}`services.ceph.osd.daemons`, and the above snippet (potentially duplicated or dynamically generated for LUKS setups), applying the configuration should now start the OSD and provide your cluster with storage.
For extended configuration such as pools, additional configuration, client side settings, etc. please consult the corresponding upstream documentation.

## Upgrades {#module-services-ceph-upgrades}

Ceph is provided via nixpkgs and thus is subject to nixpkgs' upgrade policies.
Due to the half-year release cycles of Ceph and NixOS this should mean that users of NixOS releases (i.e. not *unstable*) will likely receive major updates in new NixOS versions.
If you are on *unstable* or particularly concerned about stability you can use the usual NixOS mechanics such as module-level assertions testing for `pkgs.ceph.version == "major.minor.patch"` or similar.

To fulfill the [full upgrade procedures for Ceph clusters without cephadm as documented upstream](https://docs.ceph.com/en/latest/releases/squid/#upgrading-non-cephadm-clusters) it is necessary to restart daemons with the new version on a case-by-case basis.
If you are running a single-node cluster you can also just reboot the entire cluster at once, however if any extra version-specfic steps happen to be included in the Ceph upgrade notes a simple reboot into the new version may not allow adding these.
For a multi-node cluster rebooting the entire cluster may also be possible, though more error prone.
Any upgrade failures e.g. after upgrading the first MON may also be hidden until it is too late.
To this end it may be desirable to temporarily import the nixpkgs version including the upgrade without building the entire system with it, and then selectively overriding {option}`services.ceph.mon.package` and the corresponding options for the other daemons to achieve an incremental upgrade before switching to the new version fully.

