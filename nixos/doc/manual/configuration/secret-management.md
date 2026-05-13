# Secret Management with nixos-artifacts {#sec-nixos-artifacts}

The `security.artifacts` module provides a backend-agnostic abstraction for declaring and consuming secrets in NixOS. This decouples service modules from the specific implementation details of secret providers like `sops-nix`, `agenix`, or `systemd-creds`.

## Concept

Instead of writing service modules that explicitly depend on `sops-nix` properties (like `sops.secrets."db-pass"`), you declare secrets abstractly using `security.artifacts.secrets."db-pass"`. 

The system administrator then selects a single, global provider backend for the entire machine. The provider handles decrypting or provisioning the secret and making it available at `/run/secrets/`.

## Quick Start

Enable the system and choose your provider:

```nix
{ config, pkgs, ... }:

{
  security.artifacts.enable = true;
  security.artifacts.provider = "dummy"; # Suitable for initial testing or CI

  security.artifacts.secrets."postgres-password" = {
    owner = "postgres";
    group = "postgres";
    mode = "0400";
    dummy = "super-secret-local-password";
  };

  services.postgresql.enable = true;
  # Ensure your service starts after the secrets are ready
  systemd.services.postgresql.wants = [ "nixos-artifacts-secrets.target" ];
  systemd.services.postgresql.after = [ "nixos-artifacts-secrets.target" ];
}
```

## Security Model

The abstraction strictly enforces security invariants at evaluation time:
1. **No Nix Store Leakage:** `nixos-artifacts` uses `lib.assertMsg` to strictly verify that `secret.path` does not point to `/nix/store`. Built-in Nix functions like `builtins.readFile` are never used on secret paths.
2. **Proper Permissions:** Secrets default to `root:root` with `0400` mode, adhering to the principle of least privilege.
3. **Target Sync:** Providers hook into `nixos-artifacts-secrets.target`, meaning services can safely `wants` and `after` this target.

## Migration Guide

### From sops-nix

**Before:**
```nix
sops.secrets."my-secret" = {
  owner = "myuser";
  path = "/run/my-secret";
};
```

**After:**
```nix
security.artifacts.provider = "sops-nix";
security.artifacts.secrets."my-secret" = {
  owner = "myuser";
  path = "/run/my-secret";
};
```

### From agenix

**Before:**
```nix
age.secrets."my-secret" = {
  file = ../secrets/my-secret.age;
  owner = "myuser";
  path = "/run/my-secret";
};
```

**After:**
```nix
security.artifacts.provider = "agenix";
security.artifacts.secrets."my-secret" = {
  owner = "myuser";
  path = "/run/my-secret";
};
# Note: the provider abstracts away the expected age file path convention.
```

## CI/CD Guide

The `dummy` provider allows complete, end-to-end integration testing in NixOS VMs without requiring GPG/age keys or SOPS setup. Simply set `security.artifacts.provider = "dummy";` and the module will write the plaintext value specified in `security.artifacts.secrets.<name>.dummy` to the target path.
