# Szurubooru {#module-services-szurubooru}

An image board engine dedicated for small and medium communities.

## Configuration {#module-services-szurubooru-basic-usage}

By default the module will execute Szurubooru server only, the web client only contains static files that can be reached via a reverse proxy.

Here is a basic configuration:

```nix
{
  services.szurubooru = {
    enable = true;

    server = {
      port = 8080;

      settings = {
        domain = "https://szurubooru.domain.tld";
        secretFile = /path/to/secret/file;
      };
    };

    database = {
      passwordFile = /path/to/secret/file;
    };
  };
}
```

## Reverse proxy configuration {#module-services-szurubooru-reverse-proxy-configuration}

The prefered method to run this service is behind a reverse proxy not to expose an open port. For example, here is a minimal Nginx configuration:

```nix
{
  services.szurubooru = {
    enable = true;

    server = {
      port = 8080;
      # ...
    };

    # ...
  };

  services.nginx.virtualHosts."szurubooru.domain.tld" = {
    locations = {
      "/api/".proxyPass = "http://localhost:8080/";
      "/data/".root = config.services.szurubooru.dataDir;
      "/" = {
        root = config.services.szurubooru.client.package;
        tryFiles = "$uri /index.htm";
      };
    };
  };
}
```

## Extra configuration {#module-services-szurubooru-extra-config}

Not all configuration options of the server are available directly in this module, but you can add them in `services.szurubooru.server.settings`:

```nix
{
  services.szurubooru = {
    enable = true;

    server.settings = {
      domain = "https://szurubooru.domain.tld";
      delete_source_files = "yes";
      contact_email = "example@domain.tld";
    };
  };
}
```

You can find all of the options in the default config file available [here](https://github.com/rr-/szurubooru/blob/master/server/config.yaml.dist).
