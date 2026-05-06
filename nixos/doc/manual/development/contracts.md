# Contracts {#contracts}

A *contract* is a typed interface between a *consumer* and a *provider* of a resource. The consumer declares what it needs (a `request`); the provider declares how it fulfills any such request (a `result`). Both sides talk to a shared option tree, `config.contracts.<type>`, instead of to each other directly. This decouples the consumer from any particular implementation: as long as the contract type matches, any provider can satisfy any consumer.

Status: in development. This functionality is new in NixOS 26.05, and significant changes should be expected. Feedback is welcome in <https://github.com/NixOS/nixpkgs/pull/506343>.

The motivating example is secrets. A web app may need a password file owned by a specific user with `0400` permissions; it shouldn't have to know whether that file was produced by [`agenix`](https://github.com/ryantm/agenix), [`sops-nix`](https://github.com/Mic92/sops-nix), or written out at activation time. With a `fileSecrets` contract, the web app declares the request (owner, mode, etc.) and reads the resulting `result.path`; switching providers becomes a one-line `defaultProvider` change.

The same machinery works in [modular services](#modular-services), [Home Manager](https://github.com/nix-community/home-manager), and any other module system that imports the generic contracts module.

## Concepts {#contracts-concepts}

For each contract type, `config.contracts.<type>` exposes:

- `want.<consumer>.<...>`: entries declared by consumers, each carrying a `request` (typed by the contract's interface) and (once fulfilled) a `result`.
- `requests`: read-side view of `want`, with everything except canonical request fields stripped. Providers read this.
- `providers.<name>`: registered providers (see below).
- `defaultProvider` / `defaultProviderName`: pick which provider fulfills `want` entries when no per-instance override is set.
- `instances`: the resolved provider for each consumer/option pair (defaults to `defaultProvider`).
- `results.<consumer>.<...>`: the read-side view of `instances`, with `request` fields stripped. Consumers read this.

Contract type definitions live in `lib/contracts/templates/`; the registry is `lib.contracts`. NixOS auto-seeds `config.contractTypes` from there, and other module systems can do the same by importing `lib.contract.module` and setting `config.contractTypes = lib.contracts`.

## Consumers {#contracts-consumers}

A consumer registers entries under `contracts.<type>.want` and reads from `contracts.<type>.results`.

```nix
# nixos/modules/services/web-apps/stash.nix
{ lib, config, ... }:
let
  cfg = config.services.stash;
  inherit (contracts) fileSecrets;
in
{
  options.services.stash = {
    passwordFile = lib.mkOption {
      type = lib.types.nullOr (
        fileSecrets.mkContract {
          request = {
            owner.default = cfg.user;
            group.default = cfg.group;
          };
        }
      );
    };
  };

  config = {
    contracts.fileSecrets.want.stash = {
      inherit (cfg) passwordFile;
    };

    services.stash.passwordFile.result = config.contracts.fileSecrets.results.stash.passwordFile;
  };
}
```

`mkContract` returns a `submodule` type with the contract's `request` and `result` fields. `nestedAttrsOf` lets `want` be flat (`want.stash.secret`), grouped (`want.stash.db.primary`), or arbitrarily deep — `results` mirrors the same structure.

[Modular services](#modular-services) follow the same pattern, but the bridge automatically nests each service's `want` entries under the service's tree path, so services set `contracts.<type>.want` without a manual prefix and read results scoped to themselves.

## Providers {#contracts-providers}

A provider implements `mkProviderType` and registers itself under `contracts.<type>.providers.<name>`.

```nix
# nixos/modules/testing/hardcoded-secret.nix (excerpt)
{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  inherit (lib.contracts) fileSecrets;
in
{
  options.testing.hardcoded-secret = lib.mkOption {
    type = lib.types.submodule {
      options.fileSecrets = lib.mkOption {
        default = config.contracts.fileSecrets.requests;
        defaultText = lib.literalExpression "config.contracts.fileSecrets.requests";
        type = fileSecrets.mkProviderType {
          overrides.request = {
            owner.default = "root";
            group.default = "root";
          };
          providerOptions.content = lib.mkOption { type = lib.types.str; };
          fulfill' =
            { name, ... }:
            {
              path = "/run/hardcodedsecrets/${name}";
            };
        };
      };
    };
  };

  config.contracts.fileSecrets.providers.hardcoded-secret.module = options.testing.hardcoded-secret;
}
```

`mkProviderType { fulfill, ... }` produces a `nestedAttrsOf submodule` type whose entries each have `request`, `result`, and any `providerOptions` declared on the provider. `fulfill` (`request -> result`) or its lower-level variant `fulfill'` (`{ request, name } -> result`) computes the result from the request at `mkDefault` priority.

`providers.<name>` stores `{ module, contract? }`:

- `module` is the provider's *option set* (typically `options.services.<service>`), so downstream tooling can introspect `.loc`/`.type` for GUI generation, schema export, etc.
- `contract` is the path within `module.value` that holds the contract instances. It defaults to `[ "<contract-type>" ]` if `module.value` has that attribute (the conventional sub-option naming), and to `[ ]` when `module` itself is the contract-typed option.

For lib-only providers that don't need a wrapping submodule, the option is itself the contract option:

```nix
{ lib, options, ... }:
{
  options.services.increment.arithmetic = lib.mkOption {
    type = lib.contracts.arithmetic.mkProviderType {
      fulfill =
        { value }:
        {
          value = value + 1;
        };
    };
  };
  config.contracts.arithmetic.providers.increment.module = options.services.increment.arithmetic;
}
```

The `contract` path is inferred as `[ ]` here, since `module.value` has no `.arithmetic` attribute.

## Provider Selection {#contracts-provider-selection}

A consumer's request is fulfilled by exactly one provider per instance. There are three ways to pick one:

- `contracts.<type>.defaultProviderName = "<name>"` — by name (an enum over the registered providers).
- `contracts.<type>.defaultProvider = config.contracts.<type>.providers."<name>"` — by reference (e.g. for renamed contracts where the name changed).
- `contracts.<type>.instances."<consumer>"."<option>" = config.contracts.<type>.providers."<name>"` — per-instance override, written as a provider reference (`{ module, contract? }`); the `instances` option's `apply` resolves it at the matching path. GUIs read references as typed values rather than opaque ones.

If none of the three is set and any consumer reads `results`, evaluation fails with `contracts.<type>.defaultProvider is unset`.

Per-instance overrides compose against the `defaultProvider`-derived tree without `lib.recursiveUpdate`: `nestedAttrsOf` runs priority filtering at each leaf, so a `mkDefault` / `mkOptionDefault`-priority default at one path is preserved when another module sets a normal-priority override at a sibling path.

## Adding a Contract Type {#contracts-new-type}

A contract type lives under `lib/contracts/templates/` and exposes `meta` plus an `interface` of `request` and `result` options:

```nix
# lib/contracts/templates/my-contract.nix
{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  meta = {
    description = "What this contract is for.";
    maintainers = with lib.maintainers; [
      # ...
    ];
  };
  interface = {
    request.someInput = mkOption { type = types.str; };
    result.someOutput = mkOption { type = types.str; };
  };
}
```

Register it in `lib/contracts/templates/default.nix`:

```nix
lib.mapAttrs
  (
    _: path:
    lib.evalOption (lib.mkOption { type = lib.contract.templateType; }) (import path { inherit lib; })
  )
  {
    fileSecrets = ./file-secrets.nix;
    myContract = ./my-contract.nix;
  }
```

User-defined contract types — added directly to `config.contractTypes.<name>` rather than to nixpkgs — are also picked up automatically.

## Chaining {#contracts-chaining}

Providers can themselves be consumers. A `databaseConnection` provider can consume `fileSecrets` for credentials:

```nix
{
  lib,
  config,
  options,
  ...
}:
{
  options.services.pgProvider.databaseConnection = lib.mkOption {
    type = dbContract.mkProviderType {
      fulfill =
        { dbName }:
        {
          connectionString = "postgresql:///${dbName}?password_file=${config.contracts.fileSecrets.results.pgProvider.credential.path}";
        };
    };
  };

  config = {
    contracts.databaseConnection.providers.pgProvider.module =
      options.services.pgProvider.databaseConnection;
    contracts.fileSecrets.want.pgProvider.credential = {
      request = {
        owner = "postgres";
        group = "postgres";
      };
    };
  };
}
```

Nix's lazy evaluation resolves the chain automatically — no explicit ordering is needed.

## Cross-Node Contracts {#contracts-cross-node}

A contract spanning two NixOS nodes has no shared `config.contracts`. Evaluate the contract once in a shared `let` block and inject the resolved value into each node:

```nix
{ lib, ... }:
let
  shared =
    (lib.evalModules {
      modules = [
        ./arithmetic-contract.nix
        consumerModule
        providerModule
      ];
    }).config;
  resultValue = shared.contracts.arithmetic.results.consumer.operation.value;
in
{
  nodes.consumer = {
    imports = [
      ./arithmetic-contract.nix
      consumerModule
    ];
    environment.etc."result".text = toString resultValue;
  };
  nodes.provider = providerConfig;
}
```

Because contracts are an evaluation-time mechanism, this produces the value at derivation-build time; each node sees its slice as a literal.

## Versioning and Renames {#contracts-renames}

Renaming a request option is done with an alias module in `interface.extraImports.request`; the `requests` view filters aliases out so providers only see the canonical name. Renaming a contract type can't use `mkRenamedOptionModule` (`contracts` is one submodule-typed option), so it's done by declaring the deprecated type alongside the new one and emitting a `warnings` entry when the old `want` is non-empty. See the corresponding tests under `lib/tests/modules/contracts-{rename-warning,contract-rename}.nix` for the patterns.

## Reference {#contracts-reference}

- Generic module: [`lib/contracts/module.nix`](https://github.com/NixOS/nixpkgs/blob/master/lib/contracts/module.nix)
- NixOS wrapper: [`nixos/modules/contracts/default.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/contracts/default.nix)
- Modular services bridge: [`nixos/modules/system/service/contracts-bridge.nix`](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/system/service/contracts-bridge.nix)
- Test reference: [`lib/tests/modules/contracts-*.nix`](https://github.com/NixOS/nixpkgs/tree/master/lib/tests/modules) and [`nixos/tests/contracts/`](https://github.com/NixOS/nixpkgs/tree/master/nixos/tests/contracts)
