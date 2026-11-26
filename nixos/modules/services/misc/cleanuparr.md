# Cleanuparr {#module-services-cleanuparr}

[Cleanuparr](https://github.com/Cleanuparr/Cleanuparr) is a download queue cleaner for the *arr ecosystem. The NixOS module runs it as a systemd service.

## Basic usage {#module-services-cleanuparr-basic-usage}

Enable the service with its default SQLite database:

```nix
{
  services.cleanuparr.enable = true;
}
```

By default, Cleanuparr listens on port `11011` on all interfaces. The module does not open the firewall automatically. Set {option}`services.cleanuparr.openFirewall` to `true` to allow inbound connections to the configured port.

## Storage and service account {#module-services-cleanuparr-storage}

The service stores its configuration, SQLite database (when enabled), and ASP.NET Data Protection keyring under {option}`services.cleanuparr.dataDir`. The module sets `CLEANUPARR_CONFIG_PATH` to this directory. The module creates the data directory and assigns it to the service account. When you configure {option}`services.cleanuparr.logsDir`, the module also creates that directory and assigns it to the service account.

By default, the module creates a system user and group named `cleanuparr`. If you set {option}`services.cleanuparr.user` or {option}`services.cleanuparr.group` to a custom account or group, that account or group must already exist. Use a shared group to grant other *arr services access to files Cleanuparr manages.

By default, the application writes logs under the data directory. Set {option}`services.cleanuparr.logsDir` to use a different location. The module sets `CLEANUPARR_LOGS_PATH` to that directory.

## Network and reverse proxy {#module-services-cleanuparr-network}

{option}`services.cleanuparr.settings.port` sets the TCP port used by the web UI and API. {option}`services.cleanuparr.settings.bindAddress` sets the listening address. Set it to `0.0.0.0` or `*` to listen on all interfaces, or provide a literal IP address.

Set {option}`services.cleanuparr.settings.basePath` when serving Cleanuparr under a URL prefix, such as `/cleanuparr` behind a reverse proxy. The path must begin with `/`, cannot be `/` itself or end in `/`, and may contain only letters, numbers, hyphens, and underscores in each segment. The module rejects paths with dots or repeated slashes during Nix evaluation.

## PostgreSQL {#module-services-cleanuparr-postgresql}

SQLite is the default and requires no additional configuration. To use PostgreSQL, set {option}`services.cleanuparr.settings.database.provider` to `postgres`.

By default, the module creates a local PostgreSQL database and role using {option}`services.cleanuparr.settings.database.database` and {option}`services.cleanuparr.settings.database.user`. The module enables `services.postgresql` with `mkDefault`. The service connects over the local Unix socket using peer authentication, so you do not need a password or an additional `pg_hba.conf` entry. Peer authentication requires the service account name to match the PostgreSQL role name. For a locally provisioned database, leave `host` and `passwordFile` unset; the service does not use `port`.

To use an externally managed PostgreSQL instance, disable local provisioning and provide its host and password file:

```nix
{
  services.cleanuparr = {
    enable = true;
    settings.database = {
      provider = "postgres";
      createLocally = false;
      host = "db.example.com";
      passwordFile = "/run/secrets/cleanuparr-postgres";
    };
  };
}
```

For an external database, set `host` and `passwordFile`. The optional `port` defaults to Npgsql's default of `5432`. systemd loads the password file with `LoadCredential`. At service startup, the service script exports the credential contents to Cleanuparr as `POSTGRES_PASS`. The module keeps the password contents out of the Nix store and unit definition.

Use {option}`services.cleanuparr.settings.database.extraParams` for additional Npgsql connection-string parameters. The module passes the parameters through without Nix-level validation.

## Environment variables {#module-services-cleanuparr-environment}

The module sets environment variables for the configured port, bind address, data directory, and database. It sets variables for the URL prefix and log directory only when you configure those options.

Use {option}`services.cleanuparr.extraEnvironment` for additional non-secret variables. NixOS includes these values in the system configuration; do not put secrets in this option. Use {option}`services.cleanuparr.environmentFile` for secrets or other variables that module options do not represent. systemd reads the environment file at runtime, and Nix does not validate its contents.
