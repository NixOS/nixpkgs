# Castopod {#module-services-castopod}

Castopod is an open-source hosting platform made for podcasters who want to engage and interact with their audience.

## Quickstart {#module-services-castopod-quickstart}

Configure ACME (<https://nixos.org/manual/nixos/unstable/#module-security-acme>).
Use the following configuration to start a public instance of Castopod on `castopod.example.com` domain:

```nix
{
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  services.castopod = {
    enable = true;
    database.createLocally = true;
    nginx.virtualHost = {
      serverName = "castopod.example.com";
      enableACME = true;
      forceSSL = true;
    };
  };
}
```

Go to `https://castopod.example.com/cp-install` to create superadmin account after applying the above configuration.
