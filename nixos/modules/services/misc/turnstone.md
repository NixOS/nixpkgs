# Turnstone {#module-services-turnstone}

[Turnstone](https://github.com/turnstonelabs/turnstone) is a multi-node AI orchestration platform with tool use, agent routing, and cluster simulation.

## Basic Configuration {#module-services-turnstone-basic}

To enable the Turnstone server and console, you can use the following basic configuration:

```nix
{
  services.turnstone.server = {
    enable = true;
    port = 8080;
    settings.database.backend = "sqlite";
  };

  services.turnstone.console = {
    enable = true;
    port = 8090;
    settings.database.backend = "sqlite";
  };
}
```

## PostgreSQL Configuration {#module-services-turnstone-postgresql}

For production deployments, PostgreSQL is recommended over SQLite. Setting
`database.createLocally` (which is the default) automatically provisions
PostgreSQL databases for the server and console and connects via Unix socket
peer authentication—no passwords required:

```nix
{
  services.turnstone = {
    database.createLocally = true;

    server = {
      enable = true;
      settings.database.backend = "postgresql";
    };

    console = {
      enable = true;
      settings.database.backend = "postgresql";
    };
  };
}
```

## Secrets Management {#module-services-turnstone-secrets}

Turnstone requires several secrets (API keys, encryption keys, JWT secrets) for full functionality.
To prevent these secrets from leaking into the Nix store, they are passed via files loaded securely using systemd's `LoadCredential`.

You must provision these files out-of-band and provide their paths in your configuration:

```nix
{
  services.turnstone = {
    # JWT signing secret (e.g., generated with `openssl rand -hex 32`)
    jwtSecretFile = "/path/to/turnstone-jwt.secret";

    # MCP encryption key (e.g., generated with `openssl rand -hex 32`)
    mcpEncryptionKeyFile = "/path/to/turnstone-mcp.key";

    server.models.gpt-4o = {
      model = "gpt-4o";
      provider = "openai";
      apiKeyFile = "/path/to/openai.key";
    };
  };
}
```

Alternatively, you can provide an `EnvironmentFile` containing environment variables.

Tools like [sops-nix](https://github.com/Mic92/sops-nix) and
[agenix](https://github.com/ryantm/agenix) integrate well here—they decrypt
secrets at activation time and place them under `/run/secrets/`, which is where
the `*File` options can point.

## Model Configuration {#module-services-turnstone-models}

Register LLM models under `services.turnstone.server.models`. Each model
entry specifies the upstream model name, its provider, and a file containing
the API key:

```nix
{
  services.turnstone.server.models = {
    gpt-4o = {
      model = "gpt-4o";
      provider = "openai";
      apiKeyFile = "/run/secrets/openai-key";
    };
    claude-sonnet = {
      model = "claude-sonnet-4-20250514";
      provider = "anthropic";
      apiKeyFile = "/run/secrets/anthropic-key";
      contextWindow = 200000;
    };
  };
}
```

## MCP Servers {#module-services-turnstone-mcp}

External tool servers following the Model Context Protocol can be registered
under `services.turnstone.server.mcpServers`:

```nix
{
  services.turnstone.server.mcpServers.filesystem = {
    command = "${pkgs.mcp-server-filesystem}/bin/mcp-server-filesystem";
    args = [ "/var/lib/turnstone/workspace" ];
  };
}
```

> **Warning:** Do not place secrets directly in `services.turnstone.server.mcpServers.<name>.env`, as these values are written to `mcp.json` which is world-readable in the Nix store. Use an `EnvironmentFile` or `LoadCredential` instead.

## Reverse Proxy {#module-services-turnstone-proxy}

Both the server and console bind to `127.0.0.1` by default, so they are not
reachable from the network without additional configuration. For public or
LAN-facing deployments, place a reverse proxy such as nginx or Caddy in front
of the services.

The `services.turnstone.openFirewall` option opens the firewall for both
services, but it is rarely needed—most setups should expose the services
exclusively through a TLS-terminating reverse proxy.
