# Turnstone {#module-services-turnstone}

[Turnstone](https://github.com/turnstonelabs/turnstone) is a multi-node AI orchestration platform with tool use, agent routing, and cluster simulation.

The NixOS module configures Turnstone's deployment and bootstrap configuration.
Operational settings stored by Turnstone in `ConfigStore`, including model definitions,
are intentionally not represented as NixOS options and are managed through the Turnstone
Console or admin API.

## Architecture & Configuration Model {#module-services-turnstone-arch}

NixOS manages system resources, process isolation, secrets, and bootstrap parameters:
- **NixOS Layer**: Package, systemd services, users, state directories, database provisioning, and secret injection via `LoadCredential`.
- **Turnstone Layer**: Workstreams, model definitions, agents, tools, permissions, and operational settings persisted in the shared database.

## Basic Standalone (SQLite) {#module-services-turnstone-basic}

A minimal single-node server using SQLite:

```nix
{
  services.turnstone = {
    enable = true;
    database.backend = "sqlite";
    server.enable = true;
  };
}
```

## Recommended Setup (PostgreSQL with Server & Console) {#module-services-turnstone-postgresql}

For standard and production deployments, PostgreSQL provides shared storage between the API server and the Console dashboard. Setting `database.createLocally = true` (the default) automatically provisions the local database and connects via Unix domain socket peer authentication:

```nix
{
  services.turnstone = {
    database = {
      backend = "postgresql";
      createLocally = true;
    };

    server = {
      enable = true;
      port = 8080;
    };

    console = {
      enable = true;
      port = 8090;
    };
  };
}
```

## External PostgreSQL {#module-services-turnstone-external-pg}

When connecting to a remote or existing PostgreSQL cluster, provide the connection URL without putting credentials into the world-readable Nix store:

```nix
{
  services.turnstone = {
    database = {
      backend = "postgresql";
      createLocally = false;
      url = "postgresql://turnstone@db.internal:5432/turnstone?sslmode=verify-full";
    };

    server.enable = true;
    console.enable = true;
  };
}
```

Passwords can alternatively be passed to the service at runtime via `services.turnstone.server.environmentFile` or `console.environmentFile` containing `TURNSTONE_DB_URL`.

## Secrets Management {#module-services-turnstone-secrets}

Turnstone requires secrets (JWT tokens, OIDC secrets, MCP encryption keys) for secure operation.
To prevent secrets from leaking into `/nix/store`, secret files are loaded via systemd's `LoadCredential`:

```nix
{
  services.turnstone = {
    # JWT signing secret (e.g., generated with `openssl rand -hex 32`)
    jwtSecretFile = "/run/secrets/turnstone-jwt.secret";

    # MCP token encryption key (e.g., generated with `openssl rand -hex 32`)
    mcpEncryptionKeyFile = "/run/secrets/turnstone-mcp.key";

    # Optional OIDC client secret
    oidcClientSecretFile = "/run/secrets/turnstone-oidc.secret";
  };
}
```

Tools like [sops-nix](https://github.com/Mic92/sops-nix) or [agenix](https://github.com/ryantm/agenix) can be used to decrypt these files into `/run/secrets/`.

## Model Definitions & ConfigStore {#module-services-turnstone-models}

In Turnstone 1.8 and 1.9, models are configured dynamically:
1. Open the Turnstone Console dashboard (by default at `http://127.0.0.1:8090`).
2. Navigate to the **Models** tab.
3. Add your model endpoints (OpenAI-compatible endpoints, Anthropic, local vLLM/llama.cpp instances) and API keys.

You can also use the `turnstone-admin` CLI command or the REST API (`POST /api/admin/model-definitions`) for programmatic onboarding.

## MCP Servers {#module-services-turnstone-mcp}

External tool servers implementing the Model Context Protocol can be declared under `services.turnstone.server.mcpServers`:

```nix
{
  services.turnstone.server.mcpServers.filesystem = {
    command = "${pkgs.mcp-server-filesystem}/bin/mcp-server-filesystem";
    args = [ "/var/lib/turnstone/workspace" ];
  };
}
```

> **Warning:** Do not place secrets directly in `services.turnstone.server.mcpServers.<name>.env`, as `mcp.json` is stored in the world-readable `/nix/store`. Use `environmentFile` for process environment secrets instead.

## Reverse Proxy {#module-services-turnstone-proxy}

The server and console bind to `127.0.0.1` by default. Expose them publicly by configuring a reverse proxy such as Nginx or Caddy with TLS termination.
