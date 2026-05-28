# Secret Management with `security.artifacts` {#sec-security-artifacts}

The `security.artifacts` module provides a backend-agnostic abstraction for
declaring and consuming secrets in NixOS. It decouples service modules from
the implementation details of secret providers like `sops-nix`, `agenix`, or
`systemd-creds`.

## Motivation {#sec-security-artifacts-motivation}

NixOS service modules that handle secrets currently face a fragmentation
problem. A module author must either:

1. Hard-code support for a specific secret tool (excluding users of
   alternatives), or
2. Provide a raw `passwordFile` string option with no validation, no
   ordering guarantees, and no protection against Nix store leakage.

`security.artifacts` solves this by providing a **typed, validated interface**
that any backend can fulfill. Service modules declare *what* secrets they
need; operators choose *how* those secrets are provisioned.

## Architecture {#sec-security-artifacts-architecture}

```
┌──────────────┐    declares    ┌────────────────────────────┐
│ Service      │ ──────────▶   │ security.artifacts         │
│ Module       │   "I need     │   .secrets.<name>          │
│ (requester)  │    a secret"  │   { owner, mode, path, …}  │
└──────────────┘               └────────────┬───────────────┘
                                            │ active provider
                               ┌────────────▼───────────────┐
                               │ Provider Module             │
                               │ sops-nix | agenix |         │
                               │ systemd-creds | dummy       │
                               └────────────────────────────┘
```

All providers converge on a single systemd target:
`nixos-artifacts-secrets.target`. Services that consume secrets simply add:

```nix
systemd.services.myservice = {
  wants = [ "nixos-artifacts-secrets.target" ];
  after = [ "nixos-artifacts-secrets.target" ];
};
```

## Quick Start {#sec-security-artifacts-quickstart}

### Using the `dummy` provider (CI/CD and testing)

```nix
{
  security.artifacts.enable = true;
  security.artifacts.provider = "dummy";

  security.artifacts.secrets."db-password" = {
    owner = "postgres";
    group = "postgres";
    mode = "0400";
    dummy = "test-password-for-ci";
  };
}
```

### Using the `sops-nix` provider

```nix
{
  security.artifacts.enable = true;
  security.artifacts.provider = "sops-nix";

  security.artifacts.secrets."db-password" = {
    source = ./secrets/db-password.yaml;
    owner = "postgres";
    group = "postgres";
    mode = "0400";
  };
}
```

### Using the `agenix` provider

```nix
{
  security.artifacts.enable = true;
  security.artifacts.provider = "agenix";

  security.artifacts.secrets."db-password" = {
    source = ./secrets/db-password.age;
    owner = "postgres";
    group = "postgres";
    mode = "0400";
  };
}
```

### Using the `systemd-creds` provider

```nix
{
  security.artifacts.enable = true;
  security.artifacts.provider = "systemd-creds";

  security.artifacts.secrets."db-password" = {
    owner = "postgres";
    group = "postgres";
    mode = "0400";
  };
}
```

The credential file should be placed at `/etc/credstore/db-password`
(or `/etc/credstore.encrypted/db-password` for encrypted credentials
created with `systemd-creds encrypt`).

## Security Model {#sec-security-artifacts-security}

### Nix Store Leakage Prevention

At evaluation time, `security.artifacts` verifies that every secret's
`path` does NOT point inside `/nix/store`. This prevents the most common
class of secret management bugs in NixOS configurations — accidentally
interpolating a secret into a derivation.

If you attempt to set a store path, the build fails immediately with a
clear error:

```
security.artifacts: secret 'db-password' resolves to '/nix/store/...',
which is inside /nix/store. Use a runtime path like /run/secrets/db-password instead.
```

### Default Permissions

All secrets default to `root:root` with `0400` mode (owner-read-only).
This adheres to the principle of least privilege.

### Systemd Ordering

The `nixos-artifacts-secrets.target` guarantees that all secrets are
provisioned before any dependent service starts. This eliminates race
conditions that can occur with activation scripts.

## Switching Backends {#sec-security-artifacts-switching}

To switch from `sops-nix` to `agenix`, change only the provider line:

```nix
# Before
security.artifacts.provider = "sops-nix";

# After
security.artifacts.provider = "agenix";
```

The `source` files will need to be re-encrypted with the new tool's format,
but all service configurations and secret declarations remain unchanged.

## Migration Guide {#sec-security-artifacts-migration}

### From `sops-nix`

**Before:**
```nix
sops.secrets."my-secret" = {
  sopsFile = ./secrets/my-secret.yaml;
  owner = "myuser";
};
```

**After:**
```nix
security.artifacts.provider = "sops-nix";
security.artifacts.secrets."my-secret" = {
  source = ./secrets/my-secret.yaml;
  owner = "myuser";
};
```

### From `agenix`

**Before:**
```nix
age.secrets."my-secret" = {
  file = ./secrets/my-secret.age;
  owner = "myuser";
};
```

**After:**
```nix
security.artifacts.provider = "agenix";
security.artifacts.secrets."my-secret" = {
  source = ./secrets/my-secret.age;
  owner = "myuser";
};
```

## Writing Service Modules {#sec-security-artifacts-module-authors}

If you are a NixOS service module author, you can declare secret
requirements without depending on any specific backend:

```nix
{ config, lib, ... }:

let
  cfg = config.services.myapp;
in {
  options.services.myapp = {
    enable = lib.mkEnableOption "myapp";
  };

  config = lib.mkIf cfg.enable {
    # Declare the secret your service needs
    security.artifacts.secrets."myapp-api-key" = {
      owner = "myapp";
      group = "myapp";
      mode = "0400";
    };

    # Your service automatically gets the secret at /run/secrets/myapp-api-key
    systemd.services.myapp = {
      wants = [ "nixos-artifacts-secrets.target" ];
      after = [ "nixos-artifacts-secrets.target" ];
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/myapp --api-key-file /run/secrets/myapp-api-key";
      };
    };
  };
}
```

The operator then only needs to set `security.artifacts.provider` and
(for `sops-nix`/`agenix`) provide the `source` for each secret.
