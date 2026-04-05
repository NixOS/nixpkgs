# Wings {#module-wings}

Wings is the server backend for the Pelican Game server panel, responsible for running
the actual game servers as Docker containers. To use the panel, Wings is required (and vice versa).

It is also required to set up SSL encryption for the Wings endpoint.
This is possible directly using Wings itself, but a Reverse Proxy is recommended.

See [upstream docs](https://pelican.dev/docs/wings/install).

## Setting up a node {#module-wings-setup}

To set up a new node, go to <https://panel.your.domain/admin/nodes/create>. This will give you
a YAML configuration file, which you only need the `uuid`, `token` and `token_id` attributes of.

Then, configure them like in the traefik example below.

## Using traefik as a reverse proxy {#module-wings-traefik}

The package has support for using traefik as a reverse proxy. See the docs for `services.traefik` on how to enable it.
For example, this could look like this:

```nix
# configuration.nix
{ pkgs, ... }:
{
  services.wings = {
    enable = true;

    enableTraefik = true;
    openFirewall = true;
    domain = "server1.your.domain";

    # normally, you would use a secret manager like sops-nix,
    # do not use this in production as your secrets will be
    # world-readable in the store!
    secretEnvironmentFile = pkgs.writeText "wings-secret.yml" ''
      uuid: my-node-uuid
      token_id: supersecret
      token: long-and-super-secret
    '';
    environment.remote = "https://panel.your.domain";
  };

  services.traefik = {
    enable = true;

    staticConfigOptions = {
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entryPoint = {
            to = "websecure";
            scheme = "https";
          };
        };

        websecure = {
          address = ":443";
        };
      };

      certificatesResolvers.letsencrypt.acme = {
        email = "you@your.domain";
        storage = "/var/lib/traefik/acme.json";
        tlsChallenge = { };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      80
      443
    ];
  };
}
```
