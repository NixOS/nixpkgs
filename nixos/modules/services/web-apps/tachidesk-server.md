# Tachidesk-server {#module-services-tachidesk-server}

A free and open source manga reader server that runs extensions built for Tachiyomi.

## Basic usage {#module-services-tachidesk-server-basic-usage}

By default, the module will execute tachidesk-server backend and webUI by enabling the `tachidesk-server` service:

```
{ ... }:

{
  services.tachidesk-server = {
    enable = true
  };
}
```

It runs in the systemd service named `tachidesk-server` in the data directory `/var/lib/tachidesk-server`.

You can change the default parameters with some other parameters:
```
{ ... }:

{
  services.tachidesk-server = {
    enable = true;

    dataDir = "/var/lib/tachidesk"; # Default is "/var/lib/tachidesk-server"
    openFirewall = true;

    config = {
      port = 4567;
    };
  };
}
```

## Extra configuration {#module-services-tachidesk-server-extra-config}

Not all the configuration options are available directly in this module, but you can add the other options of tachidesk-server with:

```
{ ... }:

{
  services.tachidesk-server = {
    enable = true;

    openFirewall = true;
    config.port = 4567;
    extraConfig = {
      "server.basicAuthEnabled" = true;
      "server.basicAuthUsername" = "username";
      "server.basicAuthPassword" = "password";
    };
  };
}
```
