# Honk {#module-services-honk}

With Honk on NixOS you can quickly configure a complete ActivityPub server with
minimal setup and support costs.

## Basic usage {#module-services-honk-basic-usage}

A minimal configuration looks like this:

```nix
{
  services.honk = {
    enable = true;
    host = "0.0.0.0";
    port = 8080;
    username = "username";
    passwordFile = "/etc/honk/password.txt";
    servername = "honk.example.com";
  };

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
```
