# Samba {#module-services-samba}

[Samba](https://www.samba.org/), a SMB/CIFS file, print, and login server for Unix.

## Basic Usage {#module-services-samba-basic-usage}

A minimal configuration looks like this:

```nix
{ services.samba.enable = true; }
```

This configuration automatically enables `smbd`, `nmbd` and `winbindd` services by default.

## Configuring {#module-services-samba-configuring}

Samba configuration is located in the `/etc/samba/smb.conf` file.

### File share {#module-services-samba-configuring-file-share}

This configuration will configure Samba to serve a `public` file share
which is read-only and accessible without authentication:

```nix
{
  services.samba = {
    enable = true;
    settings = {
      "public" = {
        "path" = "/public";
        "read only" = "yes";
        "browsable" = "yes";
        "guest ok" = "yes";
        "comment" = "Public samba share.";
      };
    };
  };
}
```

### Prometheus metrics exporter {#module-services-samba-prometheus-exporter}

Samba can expose profiling metrics in Prometheus format using the
`smb_prometheus_endpoint` utility:

```nix
{
  services.samba = {
    enable = true;
    prometheusExporter.enable = true;
  };
}
```

The exporter listens on `127.0.0.1:9922` by default and serves metrics at
`/metrics`.
