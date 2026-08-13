# GNS3 Server {#module-services-gns3-server}

[GNS3](https://www.gns3.com/), a network software emulator.

## Basic Usage {#module-services-gns3-server-basic-usage}

A minimal configuration looks like this:

```nix
{
  services.gns3-server = {
    enable = true;

    auth = {
      enable = true;
      user = "gns3";
      passwordFile = "/var/lib/secrets/gns3_password";
    };

    ssl = {
      enable = true;
      certFile = "/var/lib/gns3/ssl/cert.pem";
      keyFile = "/var/lib/gns3/ssl/key.pem";
    };

    dynamips.enable = true;
    ubridge.enable = true;
    vpcs.enable = true;
  };
}
```
