# Dump1090-fa {#module-services-dump1090-fa}

[dump1090-fa](https://github.com/flightaware/dump1090) is a ADS-B, Mode S, and Mode 3A/3C demodulator and decoder that will receive and decode aircraft transponder messages received via a directly connected software defined radio, or from data provided over a network connection.

## Configuration {#module-services-dump1090-fa-configuration}

When enabled the module will automatically create a systemd service for starting the application making it write json files to `/run/dump1090-fa`.
By enabling Nginx (through `services.dump1090-fa.enableNginx`) a `dump1090-fa` virtual host serving both the static web app under `/` and the dynamically generated json files from `/run/dump1090-fa/` under `/data/` is created.

Enabling Nginx and exposing the virtual host is up to the user, here a minimal example:

```nix
{ pkgs, ... }: {
  services.dump1090-fa.enable = true;

  services.nginx = {
    enable = true;
    virtualHosts."dump1090-fa" = {
      listen = [{
        addr = "127.0.0.1";
        port = 8080;
      }];
    };
  }
}
```
