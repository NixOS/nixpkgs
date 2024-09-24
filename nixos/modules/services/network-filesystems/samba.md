# Samba {#module-services-samba}

[Samba](https://www.samba.org/), a SMB/CIFS file, print, and login server for Unix.

## Basic Usage {#module-services-samba-basic-usage}

A minimal configuration looks like this:

```nix
{
  services.samba.enable = true;
}
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
        "browseable" = "yes";
        "guest ok" = "yes";
        "comment" = "Public samba share.";
      };
    };
  };
}
```
