# Dump1090-fa {#module-services-dump1090-fa}

[dump1090-fa](https://github.com/flightaware/dump1090) is a demodulator and decoder for ADS-B, Mode S, and Mode 3A/3C aircraft transponder messages. It can receive and decode these messages from an attached software-defined radio or from data received over a network connection.

## Configuration {#module-services-dump1090-fa-configuration}

When enabled, this module automatically creates a systemd service to start the `dump1090-fa` application. The application will then write its JSON output files to `/run/dump1090-fa`.

Exposing the integrated web interface is left to the user's configuration. Below is a minimal example demonstrating how to serve it using Nginx:

```nix
{ pkgs, ... }:
{
  services.dump1090-fa.enable = true;

  services.nginx = {
    enable = true;
    virtualHosts."dump1090-fa" = {
      locations = {
        "/".alias = "${pkgs.dump1090-fa}/share/dump1090/";
        "/data/".alias = "/run/dump1090-fa/";
      };
    };
  };
}
```
