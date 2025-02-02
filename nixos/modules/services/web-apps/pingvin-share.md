# Pingvin Share {#module-services-pingvin-share}

A self-hosted file sharing platform and an alternative for WeTransfer.

## Configuration {#module-services-pingvin-share-basic-usage}

By default, the module will execute Pingvin Share backend and frontend on the ports 8080 and 3000.

I will run two systemd services named `pingvin-share-backend` and `pingvin-share-frontend` in the specified data directory.

Here is a basic configuration:

```nix
{
  services-pingvin-share = {
    enable = true;

    openFirewall = true;

    backend.port = 9010;
    frontend.port = 9011;
  };
}
```

## Reverse proxy configuration {#module-services-pingvin-share-reverse-proxy-configuration}

The prefered method to run this service is behind a reverse proxy not to expose an open port. This, you can configure Nginx such like this:

```nix
{
  services-pingvin-share = {
    enable = true;

    hostname = "pingvin-share.domain.tld";
    https = true;

    nginx.enable = true;
  };
}
```

Furthermore, you can increase the maximal size of an uploaded file with the option [services.nginx.clientMaxBodySize](#opt-services.nginx.clientMaxBodySize).
