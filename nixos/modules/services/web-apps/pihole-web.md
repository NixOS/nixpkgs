# Pi-hole Web Dashboard {#module-services-web-apps-pihole-web}

The Pi-hole suite provides a web GUI for controlling and monitoring
[pihole-FTL](index.html#module-services-networking-pihole-ftl).

## Configuration {#module-services-web-apps-pihole-web-configuration}

Example configuration:

```nix
{
  services.pihole-web = {
    enable = true;
    ports = [ 80 ];
  };
}
```

The dashboard can be configured using [{option}`services.pihole-ftl.settings`](options.html#opt-services.pihole-ftl.settings), in particular the `webserver` subsection.
