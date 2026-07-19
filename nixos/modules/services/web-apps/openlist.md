# OpenList {#module-services-openlist}

[OpenList](https://github.com/OpenListTeam/OpenList) is a file list program
that supports multiple storage providers, forked from Alist.

## Quickstart {#module-services-openlist-quickstart}

A minimal local instance listening on `http://[::1]:5244`:

```nix
{
  services.openlist = {
    enable = true;
  };
}
```

On first start, an initial random admin password is printed to the journal:

```shell
journalctl -u openlist --no-pager | grep -i "initial password"
```

Log in with it and set a new password in the web interface.

## Configuration {#module-services-openlist-configuration}

OpenList is configured through
{option}`services.openlist.settings`, which is written to
`config.json` in the state directory. See the
[upstream configuration documentation](https://doc.oplist.org/configuration/configuration)
for all available options. Options not declared in the module are passed
through verbatim.

For example, to listen on all interfaces with a fixed JWT secret:

```nix
{
  services.openlist = {
    enable = true;
    settings = {
      scheme.address = "0.0.0.0";
      jwt_secret._secret = "/run/secrets/openlist-jwt";
    };
  };
}
```

### Secrets {#module-services-openlist-secrets}

Options containing secret data should be set to an attribute set containing
the attribute `_secret`, pointing to a file that contains the value. The file
is read at service start and the option is replaced with its content, so the
secret never enters the Nix store:

```nix
{
  services.openlist.settings.database.password._secret = "/run/secrets/openlist-db-password";
}
```

### Persistent settings {#module-services-openlist-mutable-config}

By default ({option}`services.openlist.mutableConfig = true`), settings
changed at runtime through the web interface are kept: on each start, the
declarative configuration is merged into the existing `config.json`, with
declarative values taking precedence. Runtime values are preserved only where
not overridden by the declarative configuration. Set `mutableConfig` to
`false` to fully manage the configuration declaratively.

### Database {#module-services-openlist-database}

OpenList defaults to SQLite. To use MySQL or PostgreSQL instead:

```nix
{
  services.openlist.settings.database = {
    type = "postgres";
    host = "/run/postgresql";
    port = 5432;
    user = "openlist";
    password._secret = "/run/secrets/openlist-db-password";
    name = "openlist";
  };
}
```

A custom DSN can be set with
{option}`services.openlist.settings.database.dsn`, which overrides the other
connection options.

### TLS {#module-services-openlist-tls}

HTTPS can be enabled by providing a certificate and key. The files are passed
to the service through systemd credentials, so they are never copied into the
Nix store:

```nix
{
  services.openlist.settings.scheme = {
    https_port = 443;
    cert_file = "/var/lib/acme/example.org/fullchain.pem";
    key_file = "/var/lib/acme/example.org/key.pem";
  };
}
```

### Extra packages {#module-services-openlist-extra-packages}

Additional packages can be added to the service's `PATH` via
{option}`services.openlist.extraPackages`. By default the list is empty.
To enable video thumbnail generation, add `pkgs.ffmpeg-headless`:

```nix
{
  services.openlist.extraPackages = with pkgs; [
    ffmpeg-headless
  ];
}
```

### Extra flags {#module-services-openlist-extra-flags}

Extra command-line flags can be passed to the server with
{option}`services.openlist.extraFlags`, for example:

```nix
{
  services.openlist.extraFlags = [
    "--dev"
    "--no-prefix"
  ];
}
```
