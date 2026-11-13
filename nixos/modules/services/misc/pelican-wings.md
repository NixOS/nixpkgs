# Pelican Wings {#module-pelican-wings}

Wings is the server backend for the Pelican Panel, responsible for running the actual game servers as Docker containers.
The panel is required to use it (and vice versa). To set up the panel, see the docs for [](#module-pelican-panel).

If you use SSL for the panel, it is also required to set up SSL encryption for the Wings endpoint.
This is possible directly using Wings itself, but a reverse proxy is recommended.

Read the [upstream docs](https://pelican.dev/docs/wings/install) before continuing.

## Setting up a node {#module-pelican-wings-setup}

To set up a new node, go to <https://panel.your.domain/admin/nodes/create>. This will give you
a YAML configuration file, which you only need the `uuid`, `token` and `token_id` attributes of.

```nix
# configuration.nix
{ pkgs, ... }:
{
  services.pelican-wings = {
    enable = true;
    openFirewall = true;

    configuration.remote = "http://panel.example.com";
    # Secrets saved like this will be world-readable in the store:
    secretConfigurationFile = pkgs.writeText "wings-secret.yml" ''
      uuid: my-node-uuid
      token_id: supersecret
      token: long-and-super-secret
    '';
  };
}
```

The `secretConfigurationFile` option has to be set to the absolute path of a file that exists. Please use a [proper secret management scheme](https://wiki.nixos.org/wiki/Comparison_of_secret_managing_schemes) to provide it.

## Using traefik as a reverse proxy {#module-pelican-wings-traefik}

To run Wings in production, you should configure a reverse proxy. For example, this could look like this if you're using Traefik:

```nix
# configuration.nix
{ pkgs, config, ... }:
{
  services = {
    pelican-wings = {
      enable = true;
      domain = "server1.example.com";

      configuration.remote = "https://panel.example.com";
      secretConfigurationFile = pkgs.writeText "wings-secret.yml" ''
        uuid: my-node-uuid
        token_id: supersecret
        token: long-and-super-secret
      '';
    };

    traefik = {
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
          email = "alice@example.com";
          storage = "/var/lib/traefik/acme.json";
          tlsChallenge = { };
        };
      };

      dynamicConfigOptions = {
        http = {
          routers.wings = {
            entryPoints = [ "websecure" ];
            rule = "Host(`${config.services.pelican-wings.domain}`)";
            service = "wings";
            tls.certResolver = "letsencrypt";
          };

          services.wings.loadBalancer = {
            passHostHeader = true;
            servers = [ { url = "http://127.0.0.1:${toString config.services.pelican-wings.apiPort}"; } ];
          };
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      2022 # for Wings SFTP
    ];
    allowedUDPPorts = [ 443 ];
  };
}
```

