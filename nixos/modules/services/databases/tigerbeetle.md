# TigerBeetle {#module-services-tigerbeetle}

*Source:* {file}`modules/services/databases/tigerbeetle.nix`

*Upstream documentation:* <https://docs.tigerbeetle.com/>

TigerBeetle is a distributed financial accounting database designed for mission critical safety and performance.

To enable TigerBeetle, add the following to your {file}`configuration.nix`:
```nix
{
  services.tigerbeetle.enable = true;
}
```

When first started, the TigerBeetle service will create its data file at {file}`/var/lib/tigerbeetle` unless the file already exists, in which case it will just use the existing file.
If you make changes to the configuration of TigerBeetle after its data file was already created (for example increasing the replica count), you may need to remove the existing file to avoid conflicts.

## Configuring {#module-services-tigerbeetle-configuring}

By default, TigerBeetle will only listen on a local interface.
To configure it to listen on a different interface (and to configure it to connect to other replicas, if you're creating more than one), you'll have to set the `addresses` option.
Note that the TigerBeetle module won't open any firewall ports automatically, so if you configure it to listen on an external interface, you'll need to ensure that connections can reach it:

```nix
{
  services.tigerbeetle = {
    enable = true;
    addresses = [ "0.0.0.0:3001" ];
  };

  networking.firewall.allowedTCPPorts = [ 3001 ];
}
```

A complete list of options for TigerBeetle can be found [here](#opt-services.tigerbeetle.enable).

## Upgrading {#module-services-tigerbeetle-upgrading}

Usually, TigerBeetle's [upgrade process](https://docs.tigerbeetle.com/operating/upgrading) only requires replacing the binary used for the servers.
This is not directly possible with NixOS since the new binary will be located at a different place in the Nix store.

However, since TigerBeetle is managed through systemd on NixOS, the only action you need to take when upgrading is to make sure the version of TigerBeetle you're upgrading to supports upgrades from the version you're currently running.
This information will be on the [release notes](https://github.com/tigerbeetle/tigerbeetle/releases) for the version you're upgrading to.
