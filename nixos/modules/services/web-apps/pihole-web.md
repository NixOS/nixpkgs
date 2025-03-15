# Pi-hole Dashboard {#module-services-web-apps-pihole-web}

The Pi-hole suite provides a web GUI for controlling and monitoring [Pi-hole](#module-services-networking-pihole-ftl).

## Configuration {#module-services-web-apps-pihole-web-configuration}

The dashboard requires little configuration, because it is largely parsed from [the Dnsmasq configuration](#module-services-networking-dnsmasq).

An example configuration may look like:

```nix
{
  services.pihole-web = {
    enable = true;
    theme = "default-darker";
  };
}
```

Note that most settings on the *Settings* page are Dnsmasq options.
Since the configuration is immutable and comes from NixOS options, most settings cannot be changed.
