# strfry {#module-services-strfry}

strfry is a relay for the [nostr protocol](https://github.com/nostr-protocol/nostr).

## Basic usage {#module-services-strfry-basic-usage}

By default, the module will execute strfry:

```nix
{ ... }:

{
  services.strfry.enable = true;
}
```
It runs in the systemd service named `strfry`.

## Reverse Proxy {#module-services-strfry-reverse-proxy}

You can configure nginx as a reverse proxy with:

```nix
{ ... }:

{
  security.acme = {
    acceptTerms = true;
    defaults.email = "foo@bar.com";
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts."strfry.example.com" = {
    addSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.strfry.settings.relay.port}";
      proxyWebsockets = true; # nostr uses websockets
    };
  };

  services.strfry.enable = true;
}
```
