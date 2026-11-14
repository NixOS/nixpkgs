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

The preferred method to run this service is behind a reverse proxy not to expose an open port.
You can use for this the options in {option}`services.oxibooru.virtualHost`. For example, to use nginx:

```nix
{
  services.szurubooru = {
    enable = true;

    virtualHost = {
      domain = "oxibooru.domain.tld";
      nginx.enable = true;
    };

    server = {
      port = 8080;
      # ...
    };
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

You can find all of the options in the default config file available [here](https://github.com/rr-/szurubooru/blob/master/server/config.yaml.dist).
