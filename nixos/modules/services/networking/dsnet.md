# dsnet {#module-services-dsnet}

dsnet is a CLI tool to manage a centralised wireguard server. It allows easy
generation of client configuration, handling key generation, IP allocation etc.

It keeps its own configuration at `/etc/dsnetconfig.json`, which is more of a
database. It contains key material too.

The way this module works is to patch this database with whatever is configured
in the nix service instantiation. This happens automatically when required.

This way it is possible to decide what to let dnset manage and what parts you
want to keep declaratively.

```
services.dsnet = {
  enable = true;
  settings = {
    ExternalHostname = "vpn.example.com";
    Network = "10.171.90.0/24";
    Network6 = "";
    IP = "10.171.90.1";
    IP6 = "";
    DNS = "10.171.90.1";
    Networks = [ "0.0.0.0/0" ];
  };

```


See <https://github.com/naggie/dsnet> for more information.
