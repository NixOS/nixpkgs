# Yggdrasil {#module-services-networking-yggdrasil}

*Source:* {file}`modules/services/networking/yggdrasil/default.nix`

*Upstream documentation:* <https://yggdrasil-network.github.io/>

Yggdrasil is an early-stage implementation of a fully end-to-end encrypted,
self-arranging IPv6 network.

## Configuration {#module-services-networking-yggdrasil-configuration}

### Simple ephemeral node {#module-services-networking-yggdrasil-configuration-simple}

An annotated example of a simple configuration:
```
{
  services.yggdrasil = {
    enable = true;
    persistentKeys = false;
      # The NixOS module will generate new keys and a new IPv6 address each time
      # it is started if persistentKeys is not enabled.

    settings = {
      Peers = [
        # Yggdrasil will automatically connect and "peer" with other nodes it
        # discovers via link-local multicast announcements. Unless this is the
        # case (it probably isn't) a node needs peers within the existing
        # network that it can tunnel to.
        "tcp://1.2.3.4:1024"
        "tcp://1.2.3.5:1024"
        # Public peers can be found at
        # https://github.com/yggdrasil-network/public-peers
      ];
    };
  };
}
```

### Persistent node with prefix {#module-services-networking-yggdrasil-configuration-prefix}

A node with a fixed address that announces a prefix:
```
let
  address = "210:5217:69c0:9afc:1b95:b9f:8718:c3d2";
  prefix = "310:5217:69c0:9afc";
  # taken from the output of "yggdrasilctl getself".
in {

  services.yggdrasil = {
    enable = true;
    persistentKeys = true; # Maintain a fixed public key and IPv6 address.
    settings = {
      Peers = [ "tcp://1.2.3.4:1024" "tcp://1.2.3.5:1024" ];
      NodeInfo = {
        # This information is visible to the network.
        name = config.networking.hostName;
        location = "The North Pole";
      };
    };
  };

  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;
    # Forward traffic under the prefix.

  networking.interfaces.${eth0}.ipv6.addresses = [{
    # Set a 300::/8 address on the local physical device.
    address = prefix + "::1";
    prefixLength = 64;
  }];

  services.radvd = {
    # Announce the 300::/8 prefix to eth0.
    enable = true;
    config = ''
      interface eth0
      {
        AdvSendAdvert on;
        prefix ${prefix}::/64 {
          AdvOnLink on;
          AdvAutonomous on;
        };
        route 200::/8 {};
      };
    '';
  };
}
```

### Yggdrasil attached Container {#module-services-networking-yggdrasil-configuration-container}

A NixOS container attached to the Yggdrasil network via a node running on the
host:
```
let
  yggPrefix64 = "310:5217:69c0:9afc";
    # Again, taken from the output of "yggdrasilctl getself".
in
{
  boot.kernel.sysctl."net.ipv6.conf.all.forwarding" = 1;
  # Enable IPv6 forwarding.

  networking = {
    bridges.br0.interfaces = [ ];
    # A bridge only to containers…

    interfaces.br0 = {
      # … configured with a prefix address.
      ipv6.addresses = [{
        address = "${yggPrefix64}::1";
        prefixLength = 64;
      }];
    };
  };

  containers.foo = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    # Attach the container to the bridge only.
    config = { config, pkgs, ... }: {
      networking.interfaces.eth0.ipv6 = {
        addresses = [{
          # Configure a prefix address.
          address = "${yggPrefix64}::2";
          prefixLength = 64;
        }];
        routes = [{
          # Configure the prefix route.
          address = "200::";
          prefixLength = 7;
          via = "${yggPrefix64}::1";
        }];
      };

      services.httpd.enable = true;
      networking.firewall.allowedTCPPorts = [ 80 ];
    };
  };

}
```
