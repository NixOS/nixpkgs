# pihole-FTL {#module-services-networking-pihole-ftl}

*Upstream documentation*: <https://docs.pi-hole.net/ftldns/>

pihole-FTL is a fork of [Dnsmasq](index.html#module-services-networking-dnsmasq),
providing some additional features, including an API for analysis and
statistics.

Note that pihole-FTL and Dnsmasq cannot be enabled at
the same time.

## Configuration {#module-services-networking-pihole-ftl-configuration}

pihole-FTL can be configured with [{option}`services.pihole-ftl.settings`](options.html#opt-services.pihole-ftl.settings), which controls the content of `pihole.toml`.

The template pihole.toml is provided in `pihole-ftl.passthru.settingsTemplate`,
which describes all settings.

Example configuration:

```nix
{
  services.pihole-ftl = {
    enable = true;
    openFirewallDNS = true;
    openFirewallDHCP = true;
    queryLogDeleter.enable = true;
    lists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        # Alternatively, use the file from nixpkgs. Note its contents won't be
        # automatically updated by Pi-hole, as it would with an online URL.
        # url = "file://${pkgs.stevenblack-blocklist}/hosts";
        description = "Steven Black's unified adlist";
      }
    ];
    settings = {
      dns = {
        domainNeeded = true;
        expandHosts = true;
        interface = "br-lan";
        listeningMode = "BIND";
        upstreams = [ "127.0.0.1#5053" ];
      };
      dhcp = {
        active = true;
        router = "192.168.10.1";
        start = "192.168.10.2";
        end = "192.168.10.254";
        leaseTime = "1d";
        ipv6 = true;
        multiDNS = true;
        hosts = [
          # Static address for the current host
          "aa:bb:cc:dd:ee:ff,192.168.10.1,${config.networking.hostName},infinite"
        ];
        rapidCommit = true;
      };
      misc.dnsmasq_lines = [
        # This DHCP server is the only one on the network
        "dhcp-authoritative"
        # Source: https://data.iana.org/root-anchors/root-anchors.xml
        "trust-anchor=.,38696,8,2,683D2D0ACB8C9B712A1948B27F741219298D0A450D612C483AF444A4C0FB2B16"
      ];
    };
  };
}
```

### Inheriting configuration from Dnsmasq {#module-services-networking-pihole-ftl-configuration-inherit-dnsmasq}

If [{option}`services.pihole-ftl.useDnsmasqConfig`](options.html#opt-services.pihole-ftl.useDnsmasqConfig) is enabled, the configuration [options of the Dnsmasq
module](index.html#module-services-networking-dnsmasq) will be automatically
used by pihole-FTL. Note that this may cause duplicate option errors
depending on pihole-FTL settings.

See the [Dnsmasq
example](index.html#module-services-networking-dnsmasq-configuration-home) for
an exemplar Dnsmasq configuration. Make sure to set
[{option}`services.dnsmasq.enable`](options.html#opt-services.dnsmasq.enable) to false and
[{option}`services.pihole-ftl.enable`](options.html#opt-services.pihole-ftl.enable) to true instead:

```nix
{
  services.pihole-ftl = {
    enable = true;
    useDnsmasqConfig = true;
  };
}
```

### Serving on multiple interfaces {#module-services-networking-pihole-ftl-configuration-multiple-interfaces}

Pi-hole's configuration only supports specifying a single interface. If you want
to configure additional interfaces with different configuration, use
`misc.dnsmasq_lines` to append extra Dnsmasq options.

```nix
{
  services.pihole-ftl = {
    settings.misc.dnsmasq_lines = [
      # Specify the secondary interface
      "interface=enp1s0"
      # A different device is the router on this network, e.g. the one
      # provided by your ISP
      "dhcp-option=enp1s0,option:router,192.168.0.1"
      # Specify the IPv4 ranges to allocate, with a 1-day lease time
      "dhcp-range=enp1s0,192.168.0.10,192.168.0.253,1d"
      # Enable IPv6
      "dhcp-range=::f,::ff,constructor:enp1s0,ra-names,ra-stateless"
    ];
  };
}
```

## Administration {#module-services-networking-pihole-ftl-administration}

*pihole command documentation*: <https://docs.pi-hole.net/main/pihole-command>

Enabling pihole-FTL provides the `pihole` command, which can be used to control
the daemon and some configuration.

Note that in NixOS the script has been patched to remove the reinstallation,
update, and Dnsmasq configuration commands. In NixOS, Pi-hole's configuration is
immutable and must be done with NixOS options.

For more convenient administration and monitoring, see [Pi-hole
Dashboard](#module-services-web-apps-pihole-web)
