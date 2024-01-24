# pihole-FTL {#module-services-networking-pihole-ftl}

*Upstream documentation*: <https://docs.pi-hole.net/ftldns/>

pihole-FTL is a fork of [Dnsmasq](#module-services-networking-dnsmasq),
providing some additional features, including an API for analysis and
statistics.

This module uses the configuration from [](#module-services-networking-dnsmasq).
Note that pihole-FTL and Dnsmasq cannot be enabled at
the same time.

## Configuration {#module-services-networking-pihole-configuration}

See the [Dnsmasq
example](#module-services-networking-dnsmasq-configuration-home) for the
required Dnsmasq configuration. Make sure to set
[](#opt-services.dnsmasq.enable) to false and
[](#opt-services.pihole-ftl.enable) to true instead:

```nix
{
  services.pihole-ftl = {
    enable = true;
    adlists = [
      {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
        comment = "Steven Black's unified adlist";
      }
    ];
    extraSetupVars = {
      API_QUERY_LOG_SHOW = "blockedonly";
    };
  };
}
```

## Administration {#module-services-networking-pihole-ftl-administration}

*pihole command documentation*: <https://docs.pi-hole.net/core/pihole-command>

Enabling pihole-FTL provides the `pihole` command, which can be used to control
the daemon and the configuration database in `/etc/pihole/`. This includes
blocking/allowing specific URLs, and adding adlists, e.g. **pihole -a adlist add
https://example.com/adlist.txt**.

Note that in NixOS the script is patched to disable the reinstallation, update,
and Dnsmasq configuration commands. In NixOS, Pi-hole's configuration is
immutable and must be done with NixOS options.

For more convenient administration and monitoring, see [Pi-hole
Dashboard](#module-services-web-apps-pihole-web).
