# Oxibooru {#module-services-oxibooru}

An image board engine based on Szurubooru.

## Configuration {#module-services-oxibooru-basic-usage}

By default the module will execute Oxibooru server only, the web client only contains static files that can be reached via a reverse proxy.

Here is a basic configuration:

```nix
{
  services.oxibooru = {
    enable = true;

    server = {
      port = 8080;

      settings = {
        domain = "https://oxibooru.domain.tld";
        secretFile = /path/to/secret/file;
      };
    };

    database = {
      passwordFile = /path/to/secret/file;
    };
  };
}
```

## Reverse proxy configuration {#module-services-oxibooru-reverse-proxy-configuration}

The preferred method to run this service is behind a reverse proxy not to expose an open port. For example, here is a minimal Nginx configuration:

```nix
{
  services.oxibooru = {
    enable = true;

    server = {
      port = 8080;
      # ...
    };

    # ...
  };

  services.nginx.virtualHosts."oxibooru.domain.tld" = {
    locations = {
      "/api/".proxyPass = "http://localhost:8080/";
      "/data/".root = config.services.oxibooru.dataDir;
      "/" = {
        root = config.services.oxibooru.client.package;
        tryFiles = "$uri /index.htm";
      };
    };
  };
}
```

## Extra configuration {#module-services-oxibooru-extra-config}

Not all configuration options of the server are available directly in this module, but you can add them in `services.oxibooru.server.settings`.

You can find all of the options in the default config file available [here](https://github.com/liamw1/oxibooru/blob/master/server/config.toml.dist).
