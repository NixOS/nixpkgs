# Lemmy {#module-services-lemmy}

Lemmy is a federated alternative to Reddit in Rust.

## Quickstart {#module-services-lemmy-quickstart}

The minimum to start Lemmy is

```nix
{
  services.lemmy = {
    enable = true;
    settings.hostname = "lemmy.union.rocks";
    database.createLocally = true;
    caddy.enable = true;
  };
}
```

This will start the backend on port 8536 and the frontend on port 1234.
It will expose your instance with a Caddy reverse proxy to the hostname you've provided.
Postgres will be initialized on that same instance automatically.

## Usage {#module-services-lemmy-usage}

On first connection you will be asked to define an admin user.

## Missing {#module-services-lemmy-missing}

- This has been tested using a local database with a Unix socket connection. Using different database settings will likely require modifications.
