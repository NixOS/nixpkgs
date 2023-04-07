# Castopod {#module-services-castopod}

Castopod is an open-source hosting platform made for podcasters who want engage and interact with their audience.

## Quickstart {#module-services-castopod-quickstart}

Use the following configuration to start public instance of Castopod on `castopod.example.com` domain:

```nix
networking.firewall.allowedTCPPorts = [ 80 443 ];
services.castopod = {
  enable = true;
  database.createLocally = true;
  nginx.virtualHost = {
    serverName = "castopod.example.com";
    enableACME = true;
    forceSSL = true;
  };
};
```

Go to `https://castopod.example.com/cp-install` to create superadmin account after applying the above configuration.
