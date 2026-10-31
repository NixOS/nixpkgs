# GARM {#module-garm}

[GARM](https://github.com/cloudbase/garm) manages pools of self-hosted runners
for GitHub Actions and Gitea Actions. Runners are created on demand through
pluggable providers, for example [garm-provider-incus](https://github.com/cloudbase/garm-provider-incus),
which runs them as Incus containers or virtual machines.

This module configures the GARM daemon. Everything GARM manages (forge
credentials, repositories and runner pools) lives in its database, and for now
has to be set up imperatively with `garm-cli` once the service runs, see
[first steps](https://github.com/cloudbase/garm/blob/main/doc/first-steps.md)
upstream.

## Secrets {#module-garm-secrets}

GARM requires `jwt_auth.secret` and `database.passphrase` to be set, and
validates both: the passphrase must be exactly 32 characters, the secret has no
length requirement, and both values have to pass a password strength check. The
commands below generate a 48 character secret and a 32 character passphrase.

```ShellSession
# install -d -m 0700 /var/lib/secrets
# tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 48 > /var/lib/secrets/garm-jwt-secret
# tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32 > /var/lib/secrets/garm-db-passphrase
# chmod 0400 /var/lib/secrets/garm-*
```

::: {.warning}
Changing `database.passphrase` invalidates all secrets already encrypted in the
database, changing `jwt_auth.secret` invalidates all tokens issued to runners.
Keep both stable and back them up together with the database.
:::

GARM reads its configuration from a single file and cannot pick up secrets from
the environment. Settings that hold secret data are therefore given as an
attribute set `{ _secret = "/path/to/file"; }`, and the module substitutes the
file contents on startup. The files are read through systemd credentials, so
they only need to be readable by root:

```nix
{
  services.garm = {
    enable = true;
    settings = {
      jwt_auth.secret._secret = "/var/lib/secrets/garm-jwt-secret";
      database.passphrase._secret = "/var/lib/secrets/garm-db-passphrase";
    };
  };
}
```

## Providers {#module-garm-providers}

Providers are external executables that GARM calls to create and delete
runners. They are declared in `settings.provider` and take their own
configuration file:

```nix
{
  services.garm.settings.provider = [
    {
      name = "incus";
      description = "Incus external provider";
      provider_type = "external";
      external = {
        provider_executable = lib.getExe pkgs.garm-provider-incus;
        config_file = pkgs.writers.writeTOML "garm-provider-incus.toml" {
          unix_socket_path = "/var/lib/incus/unix.socket";
          instance_type = "container";
          project_name = "default";
          include_default_profile = false;
          image_remotes.images = {
            addr = "https://images.linuxcontainers.org";
            public = true;
            protocol = "simplestreams";
          };
        };
      };
    }
  ];
}
```

The service runs as a dynamic user in a restricted environment, so it needs to
be granted access to whatever the provider talks to. For Incus:

```nix
{
  systemd.services.garm.serviceConfig.SupplementaryGroups = [ "incus-admin" ];
}
```

A provider that needs more than a socket, for example a device or a writable
path, needs the corresponding systemd sandboxing option relaxed in
`systemd.services.garm.serviceConfig` as well.

Images must have `cloud-init` installed, as that is how GARM bootstraps the
runner. The images of the remote above come in variants, of which only the ones
suffixed `/cloud` include `cloud-init`.

## Reachability {#module-garm-reachability}

Runners fetch their configuration from GARM and report back to it, so the
address GARM is initialized with must be reachable from the runners.
With runners on an Incus bridge, bind GARM to all interfaces
and keep the port closed on the public ones:

```nix
{
  services.garm.settings.apiserver.bind = "0.0.0.0";
  networking.firewall.trustedInterfaces = [ "incusbr0" ];
}
```

::: {.note}
GARM serves its API, the runner metadata endpoints and, if enabled with
`settings.apiserver.webui.enable`, a web UI on the same port. Do not open that
port to untrusted networks without putting a reverse proxy in front of it.
:::

## Initial setup {#module-garm-setup}

Once the service runs, initialize the controller and add credentials, an entity
and a pool as described in the [upstream
documentation](https://github.com/cloudbase/garm/blob/main/doc/first-steps.md).
Pass `garm-cli init` the address the runners use, not `localhost`:

```ShellSession
$ garm-cli init --name garm --url http://10.0.10.1:9997
```
