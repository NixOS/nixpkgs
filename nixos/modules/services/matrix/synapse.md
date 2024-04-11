# Matrix {#module-services-matrix}

[Matrix](https://matrix.org/) is an open standard for
interoperable, decentralised, real-time communication over IP. It can be used
to power Instant Messaging, VoIP/WebRTC signalling, Internet of Things
communication - or anywhere you need a standard HTTP API for publishing and
subscribing to data whilst tracking the conversation history.

This chapter will show you how to set up your own, self-hosted Matrix
homeserver using the Synapse reference homeserver, and how to serve your own
copy of the Element web client. See the
[Try Matrix Now!](https://matrix.org/docs/projects/try-matrix-now.html)
overview page for links to Element Apps for Android and iOS,
desktop clients, as well as bridges to other networks and other projects
around Matrix.

## Synapse Homeserver {#module-services-matrix-synapse}

[Synapse](https://github.com/element-hq/synapse) is
the reference homeserver implementation of Matrix from the core development
team at matrix.org. The following configuration example will set up a
synapse server for the `example.org` domain, served from
the host `myhostname.example.org`. For more information,
please refer to the
[installation instructions of Synapse](https://element-hq.github.io/synapse/latest/setup/installation.html) .
```nix
{ pkgs, lib, config, ... }:
let
  fqdn = "${config.networking.hostName}.${config.networking.domain}";
  baseUrl = "https://${fqdn}";
  clientConfig."m.homeserver".base_url = baseUrl;
  serverConfig."m.server" = "${fqdn}:443";
  mkWellKnown = data: ''
    default_type application/json;
    add_header Access-Control-Allow-Origin *;
    return 200 '${builtins.toJSON data}';
  '';
in {
  networking.hostName = "myhostname";
  networking.domain = "example.org";
  networking.firewall.allowedTCPPorts = [ 80 443 ];

  services.postgresql.enable = true;
  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    virtualHosts = {
      # If the A and AAAA DNS records on example.org do not point on the same host as the
      # records for myhostname.example.org, you can easily move the /.well-known
      # virtualHost section of the code to the host that is serving example.org, while
      # the rest stays on myhostname.example.org with no other changes required.
      # This pattern also allows to seamlessly move the homeserver from
      # myhostname.example.org to myotherhost.example.org by only changing the
      # /.well-known redirection target.
      "${config.networking.domain}" = {
        enableACME = true;
        forceSSL = true;
        # This section is not needed if the server_name of matrix-synapse is equal to
        # the domain (i.e. example.org from @foo:example.org) and the federation port
        # is 8448.
        # Further reference can be found in the docs about delegation under
        # https://element-hq.github.io/synapse/latest/delegate.html
        locations."= /.well-known/matrix/server".extraConfig = mkWellKnown serverConfig;
        # This is usually needed for homeserver discovery (from e.g. other Matrix clients).
        # Further reference can be found in the upstream docs at
        # https://spec.matrix.org/latest/client-server-api/#getwell-knownmatrixclient
        locations."= /.well-known/matrix/client".extraConfig = mkWellKnown clientConfig;
      };
      "${fqdn}" = {
        enableACME = true;
        forceSSL = true;
        # It's also possible to do a redirect here or something else, this vhost is not
        # needed for Matrix. It's recommended though to *not put* element
        # here, see also the section about Element.
        locations."/".extraConfig = ''
          return 404;
        '';
        # Forward all Matrix API calls to the synapse Matrix homeserver. A trailing slash
        # *must not* be used here.
        locations."/_matrix".proxyPass = "http://[::1]:8008";
        # Forward requests for e.g. SSO and password-resets.
        locations."/_synapse/client".proxyPass = "http://[::1]:8008";
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    settings.server_name = config.networking.domain;
    # The public base URL value must match the `base_url` value set in `clientConfig` above.
    # The default value here is based on `server_name`, so if your `server_name` is different
    # from the value of `fqdn` above, you will likely run into some mismatched domain names
    # in client applications.
    settings.public_baseurl = baseUrl;
    settings.listeners = [
      { port = 8008;
        bind_addresses = [ "::1" ];
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [ {
          names = [ "client" "federation" ];
          compress = true;
        } ];
      }
    ];
  };
}
```

## Registering Matrix users {#module-services-matrix-register-users}

If you want to run a server with public registration by anybody, you can
then enable `services.matrix-synapse.settings.enable_registration = true;`.
Otherwise, or you can generate a registration secret with
{command}`pwgen -s 64 1` and set it with
[](#opt-services.matrix-synapse.settings.registration_shared_secret).
To create a new user or admin from the terminal your client listener
must be configured to use TCP sockets. Then you can run the following
after you have set the secret and have rebuilt NixOS:
```ShellSession
$ nix-shell -p matrix-synapse
$ register_new_matrix_user -k your-registration-shared-secret http://localhost:8008
New user localpart: your-username
Password:
Confirm password:
Make admin [no]:
Success!
```
In the example, this would create a user with the Matrix Identifier
`@your-username:example.org`.

::: {.warning}
When using [](#opt-services.matrix-synapse.settings.registration_shared_secret), the secret
will end up in the world-readable store. Instead it's recommended to deploy the secret
in an additional file like this:

  - Create a file with the following contents:

    ```
    registration_shared_secret: your-very-secret-secret
    ```
  - Deploy the file with a secret-manager such as
    [{option}`deployment.keys`](https://nixops.readthedocs.io/en/latest/overview.html#managing-keys)
    from {manpage}`nixops(1)` or [sops-nix](https://github.com/Mic92/sops-nix/) to
    e.g. {file}`/run/secrets/matrix-shared-secret` and ensure that it's readable
    by `matrix-synapse`.
  - Include the file like this in your configuration:

    ```nix
    {
      services.matrix-synapse.extraConfigFiles = [
        "/run/secrets/matrix-shared-secret"
      ];
    }
    ```
:::

::: {.note}
It's also possible to user alternative authentication mechanism such as
[LDAP (via `matrix-synapse-ldap3`)](https://github.com/matrix-org/matrix-synapse-ldap3)
or [OpenID](https://element-hq.github.io/synapse/latest/openid.html).
:::

## Element (formerly known as Riot) Web Client {#module-services-matrix-element-web}

[Element Web](https://github.com/vector-im/riot-web/) is
the reference web client for Matrix and developed by the core team at
matrix.org. Element was formerly known as Riot.im, see the
[Element introductory blog post](https://element.io/blog/welcome-to-element/)
for more information. The following snippet can be optionally added to the code before
to complete the synapse installation with a web client served at
`https://element.myhostname.example.org` and
`https://element.example.org`. Alternatively, you can use the hosted
copy at <https://app.element.io/>,
or use other web clients or native client applications. Due to the
`/.well-known` urls set up done above, many clients should
fill in the required connection details automatically when you enter your
Matrix Identifier. See
[Try Matrix Now!](https://matrix.org/docs/projects/try-matrix-now.html)
for a list of existing clients and their supported featureset.
```nix
{
  services.nginx.virtualHosts."element.${fqdn}" = {
    enableACME = true;
    forceSSL = true;
    serverAliases = [
      "element.${config.networking.domain}"
    ];

    root = pkgs.element-web.override {
      conf = {
        default_server_config = clientConfig; # see `clientConfig` from the snippet above.
      };
    };
  };
}
```

::: {.note}
The Element developers do not recommend running Element and your Matrix
homeserver on the same fully-qualified domain name for security reasons. In
the example, this means that you should not reuse the
`myhostname.example.org` virtualHost to also serve Element,
but instead serve it on a different subdomain, like
`element.example.org` in the example. See the
[Element Important Security Notes](https://github.com/vector-im/element-web/tree/v1.10.0#important-security-notes)
for more information on this subject.
:::
