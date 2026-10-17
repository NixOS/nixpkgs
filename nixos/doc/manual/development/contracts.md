# Contracts {#contracts}

A contract is an interface between a *consumer* and a *provider* of a resource.
The consumer tells what it needs in a `request`.
The provider supplies the resource and tells the consumer about it in a `response`.

Each contract type has an interface module that declares the options `request` and `response`.
The consumer and the provider import the same interface module.
Thus, a consumer can use each provider of the contract type, and does not depend on one specific provider.

Status: experimental. The interfaces can change.

This chapter describes how contracts work in general.
The examples use the file secrets contract type `lib.contracts.fileSecrets`, its consumer `services.stash` and its test provider `testing.hardcoded-secret`.
For the `request` and `response` options of a contract type, refer to the options of that contract type in [](#opt-contracts), for example [](#opt-contracts.fileSecrets).
For the behavior of a provider, refer to the options of the provider, for example [](#opt-testing.hardcoded-secret.fileSecrets).

## Consumers {#contracts-consumers}

A consumer declares an option with a submodule type that imports the interface module.
With option declaration merging, the consumer can add a `default` to an option of the interface, or make it `readOnly`.

Example, a simplified version of the consumer option `services.stash.passwordFile`:

```nix
{
  options.services.stash.passwordFile = lib.mkOption {
    type = lib.types.submodule {
      imports = [ lib.contracts.fileSecrets.interface ];
      options.request = lib.mkOption {
        default = { };
        type = lib.types.submodule {
          options.owner = lib.mkOption {
            default = cfg.user;
            readOnly = true;
          };
        };
      };
    };
  };
}
```

The function `mkContract` of a contract type makes the same type from a set of overrides.
For each option of the interface, such as `request`, give the attributes to add to its options.
Example, the consumer option from the example before, with `mkContract`:

```nix
{
  options.services.stash.passwordFile = lib.mkOption {
    type = lib.contracts.fileSecrets.mkContract {
      request.owner = {
        default = cfg.user;
        readOnly = true;
      };
    };
  };
}
```

`mkContract` also defines each option in the overrides as `{ }`, so that the user can omit `request` if each option of `request` has a default.
In the type from `mkContract`, `response` also has the options of `request`, without their defaults, so that it can hold a value from `results`.

The consumer reads the resource from `response`.
In the example, the path of the secret file is `cfg.passwordFile.response.path`.

A consumer can also accept a value without a contract, with `types.oneOf`.
For example, `services.stash.passwordFile` also accepts a plain path, with `types.oneOf [ types.path contractType ]`.
`lib.contract.isInstance` tells which of the two the user set: it is `true` for an attribute set with a `response`.

## Providers {#contracts-providers}

A provider declares an attribute set of submodules that import the same interface module.
The provider sets a `default` for each option in `response`, and uses the options in `request` to make the resource.

Options that are specific to the provider go in `providerOptions`.
Do not add other options at the top level of an entry. That level is for the contract.
The contract type declares the options at the top level, and a new version of the contract type can add an option there.
The contract type and the providers do not agree on the names of the provider options.
If a provider declares an option at the top level, a new option of the contract type can have the same name, and the two declarations then conflict.
In `providerOptions`, an option of the provider cannot conflict with an option of the contract type.
`request` and `response` are not in a namespace, because the contract type declares them.

Example, a provider option of the contract type `fileSecrets`:

```nix
{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.testing.hardcoded-secret;
  opt = options.testing.hardcoded-secret;
in
{
  options.testing.hardcoded-secret.fileSecrets = lib.mkOption {
    type = lib.types.nestedAttrsOf (
      lib.types.submodule (
        { options, ... }:
        let
          # Path of this entry in `fileSecrets`, for example `[ "stash" "passwordFile" ]`.
          entryPath = lib.drop (lib.length opt.fileSecrets.loc) (lib.init options.response.loc);
        in
        {
          imports = [ lib.contracts.fileSecrets.interface ];
          options.response = lib.mkOption {
            default = { };
            type = lib.types.submodule {
              options.path = lib.mkOption {
                default = "${cfg.directory}/${lib.concatStringsSep "/" entryPath}";
              };
            };
          };
          options.providerOptions = lib.mkOption {
            default = { };
            type = lib.types.submodule {
              options.content = lib.mkOption { type = lib.types.str; };
            };
          };
        }
      )
    );
  };
}
```

The entries can be in nested attribute sets, as in [`want`](#contracts-routing).
Use the path of an entry, and not only its name, to make a unique resource for each entry.
Two consumers can use the same option name.
To apply a function to each entry, use `lib.concatMapNestedAttrs'` with the type of the option.

The function `mkProviderType` of a contract type makes a type of the same shape.
`overrides` adds attributes to the options of the interface, as in `mkContract`.
`providerOptions` contains the options of `providerOptions`.
`fulfill` is a function from the `request` of an entry to its `response`.
Example, a simplified version of the provider option `testing.hardcoded-secret.fileSecrets`, which declares the same option as the example before with `mkProviderType`:

```nix
{
  config,
  lib,
  options,
  ...
}:
let
  cfg = config.testing.hardcoded-secret;
  opt = options.testing.hardcoded-secret;
in
{
  options.testing.hardcoded-secret.fileSecrets = lib.mkOption {
    type = lib.contracts.fileSecrets.mkProviderType {
      overrides.request = {
        owner.default = "root";
        group.default = "root";
      };
      providerOptions.content = lib.mkOption { type = lib.types.str; };
      fulfill' =
        { loc, ... }:
        {
          path = "${cfg.directory}/${lib.concatStringsSep "/" (lib.drop (lib.length opt.fileSecrets.loc) loc)}";
        };
    };
  };
}
```

Use `fulfill'` if the response also needs the location `loc` of the entry, its last attribute name `name`, or its configuration `instance`.
Each attribute of the response from `fulfill` or `fulfill'` has `mkDefault` priority.
Thus a definition of a `response` option replaces it.

## Connect a consumer to a provider {#contracts-connect}

The user connects each consumer option to a provider entry.
The user sets the `request` of the provider entry from the consumer, and the `response` of the consumer from the provider entry.
Example, with the consumer and the provider from the examples before:

```nix
{ config, ... }:
{
  services.stash.passwordFile.response =
    config.testing.hardcoded-secret.fileSecrets.stash-password.response;

  testing.hardcoded-secret.fileSecrets.stash-password = {
    request = config.services.stash.passwordFile.request;
    providerOptions.content = "MyPassword";
  };
}
```

To use a different provider, change these two definitions.
[](#opt-contracts) can also make these connections, refer to [](#contracts-routing).

## Contract types {#contracts-types}

`lib.contracts` contains the contract types of nixpkgs.
Each contract type has `meta.description`, `meta.maintainers`, an `interface` module, and the functions `mkContract` and `mkProviderType`.

The option [](#opt-contractTypes) contains the contract types that a configuration can use.
In NixOS, it contains each contract type in `lib.contracts`.
For each contract type, [](#opt-contracts) has an option with its `meta.description`, and with its `request` and `response` options under `want`.
The type of a contract type is `lib.contract.definitionType`.

To add a contract type, write its `meta` and `interface` in a new file in `lib/contracts/definitions`, and add that file to `lib/contracts/definitions/default.nix`.
A configuration can also define a contract type in `contractTypes`, for example to use it in a test.

The routing module is `lib.contract.module`.
It does not depend on NixOS, so other module systems can also import it.

## Route requests to a provider {#contracts-routing}

For each contract type, [](#opt-contracts) sends the requests of consumers to a provider, and sends the responses back:

- `contracts.<type>.want.<consumer>.<option>`: an entry with a `request` from a consumer.
  Each consumer puts its entries in an attribute set with its own name.
  Entries can be in nested attribute sets of any depth, for example `want.<consumer>.db.primary`.
  An attribute set that contains only names of interface options, such as `request`, is an entry and not a namespace.
  Empty attribute sets, for example from `mkIf false`, do not go to a provider.
- `contracts.<type>.providers.<provider>`: where to find the *provider option*, the option of the provider that has an entry for each request that the provider fulfills, at the same path as in `want`.
  `module` is the options of the provider, and `contract` is the path of the provider option in `module`.
- `contracts.<type>.defaultProvider`: the provider that gets the requests, one of `providers`.
- `contracts.<type>.defaultProviderName`: the name of the provider in `providers` that gets the requests.
  This sets the default of `defaultProvider`.
- `contracts.<type>.instances.<consumer>.<option>`: the provider that gets the entry at the same path in `want`.
  The default is `defaultProvider`.
- `contracts.<type>.providerRequests.<provider>`: the requests that a provider must fulfill.
  These are the entries of `want` that `instances` sends to the provider, and `{ }` for providers not routed to fulfill requests.
- `contracts.<type>.results.<consumer>.<option>`: for each entry in `want`, at the same path, the `request` of the entry and the `response` from the provider in `instances` in one attribute set.
  A `response` attribute takes precedence over a `request` attribute with the same name.
- `contracts.<type>.warnings`: the warnings of the aliases that the entries in `want` set. See [](#contracts-rename-request).

A provider reads `providerRequests.<provider>` into its provider option, and sets `providers.<provider>.module` to its options.
`providers.<provider>.contract` is the path of the provider option in `module`:

- By convention, the provider option is an option in `module` with the name of the contract type, for example `options.testing.hardcoded-secret.fileSecrets`.
  The default of `contract`, `[ "<type>" ]`, finds this provider option, thus the provider does not set `contract`.
- If the provider option has a different name, or is in a nested set of options, set `contract` to its path in `module`.
- If `module` is the provider option, set `contract` to `[ ]`.
- If the path gets to an option before its end, the remaining path is in the value of that option.

Use the convention if possible: then the provider option of each provider has the same path in its options.
With `module`, a tool can find the other options of the provider, for example to make a configuration form for the provider.
In such a form, the options in `module` apply to the full provider, and the options in `providerOptions` of the provider option apply to one entry.

Example, the provider `testing.hardcoded-secret` of the contract type `fileSecrets`:

```nix
{ config, options, ... }:
{
  testing.hardcoded-secret.fileSecrets =
    config.contracts.fileSecrets.providerRequests.hardcoded-secret;
  contracts.fileSecrets.providers.hardcoded-secret.module = options.testing.hardcoded-secret;
}
```

Example, a provider with the provider option at `services.bar.secrets.files`:

```nix
{ options, ... }:
{
  contracts.fileSecrets.providers.bar = {
    module = options.services.bar;
    contract = [
      "secrets"
      "files"
    ];
  };
}
```

A consumer module sends the `request` of its options to `want`.
Example, a simplified version of the consumer option `services.stash.passwordFile`:

```nix
{ config, lib, ... }:
let
  cfg = config.services.stash;
in
{
  options.services.stash.passwordFile = lib.mkOption {
    type = lib.types.submodule {
      imports = [ lib.contracts.fileSecrets.interface ];
    };
  };

  config.contracts.fileSecrets.want.stash.passwordFile = {
    inherit (cfg.passwordFile) request;
  };
}
```

The consumer does not set a default for `response`, thus the user must connect each option.
This is because a provider such as `testing.hardcoded-secret` is not safe for production.
The user selects the provider, sets the `response` of the consumer from `results`, and sets the options of the provider for each request.
Example, with the consumer from the example before and the provider `testing.hardcoded-secret`:

```nix
{ config, ... }:
{
  contracts.fileSecrets.defaultProvider = config.contracts.fileSecrets.providers.hardcoded-secret;
  services.stash.passwordFile.response = config.contracts.fileSecrets.results.stash.passwordFile;
  testing.hardcoded-secret.fileSecrets.stash.passwordFile.providerOptions.content = "MyPassword";
}
```

Instead of `defaultProvider`, the user can set the name of the provider:

```nix
{
  contracts.fileSecrets.defaultProviderName = "hardcoded-secret";
}
```

To use a different provider, change `defaultProvider` or `defaultProviderName`, and set the options of that provider.

To send one entry to a different provider, set `instances` at the path of the entry to that provider:

```nix
{ config, ... }:
{
  contracts.fileSecrets.instances.stash.passwordFile =
    config.contracts.fileSecrets.providers.other-provider;
}
```

To connect one entry manually, as in [](#contracts-connect), set `instances` at the path of the entry to `null`.
Then no provider gets the request of that entry from `providerRequests`, and `results` at that path is not available.

## Chain contracts {#contracts-chaining}

A provider of one contract type can also be a consumer of a different contract type.
For example, a provider of database connections can request a file secret for its password, and put the path of the file in each connection string:

```nix
{ config, lib, ... }:
let
  credential = config.contracts.fileSecrets.results.pgProvider.credential;
in
{
  options.services.pgProvider.databaseConnection = lib.mkOption {
    type = config.contractTypes.databaseConnection.mkProviderType {
      fulfill = request: {
        connectionString = "postgresql:///${request.dbName}?password_file=${credential.path}";
      };
    };
  };

  config.contracts.fileSecrets.want.pgProvider.credential.request = {
    owner = "postgres";
    group = "postgres";
  };
}
```

The module system evaluates options lazily, thus the order of the modules has no effect.
If a response depends on itself, the evaluation fails with infinite recursion.

## Connect nodes {#contracts-cross-node}

Each NixOS node has its own [](#opt-contracts).
If the consumer and the provider are on different nodes, connect the two nodes:

- On the provider node, set `want` to the `requests` of the consumer node.
- On the consumer node, set `defaultProvider` to the `defaultProvider` of the provider node.

The consumer module and the provider module do not change.
The response must be correct on the consumer node.
For example, a URL can be correct, but the path of a file on the provider node is not.

In a NixOS test, the module argument `nodes` contains the configuration of each node:

```nix
{
  nodes.provider =
    { nodes, ... }:
    {
      contracts.myContract.want = nodes.consumer.contracts.myContract.requests;
    };

  nodes.consumer =
    { nodes, ... }:
    {
      contracts.myContract.defaultProvider = nodes.provider.contracts.myContract.defaultProvider;
    };
}
```

## Rename a request option {#contracts-rename-request}

To rename an option of `request`, add a module with an alias to `requestAliases` of the contract type.
For example, to rename the option `request.oldValue` to `request.value`:

```nix
{
  requestAliases = [ (lib.mkRenamedOptionModule [ "oldValue" ] [ "value" ]) ];
}
```

The paths are relative to `request`.
Consumers can then set the old name or the new name.
The value of `request` has only the options of `interface`, thus a consumer can forward its `request` to `want`.
Providers get only the options of `interface`, and the `request` in `results` also has only these options.

When a consumer sets the old name, the warning goes to `contracts.<type>.warnings`.
In NixOS, these warnings go to the option `warnings`.

## Rename a contract type {#contracts-rename-type}

To rename a contract type, add `lib.mkRenamedOptionModule` to [](#opt-contracts).
For example, to rename the contract type `oldContract` to `newContract`:

```nix
{
  contracts =
    { ... }:
    {
      imports = [ (lib.mkRenamedOptionModule [ "oldContract" ] [ "newContract" ]) ];
    };
}
```

The paths are relative to `contracts`.
Use a function, because the module system reads an attribute set in `contracts` as values of its options, and not as a module with `imports`.
Consumers of `oldContract` do not change: their entries in `want` go to `newContract`, and they read `results` of `newContract`.
When a consumer sets the old name, the warning goes to `contracts.warnings`.
In NixOS, these warnings go to the option `warnings`.

In nixpkgs, rename the contract type in `lib/contracts/definitions/`, and add the module to `nixos/modules/contracts/default.nix`.
`lib.contracts` does not keep the old name, thus a module that uses `lib.contracts.oldContract` must change to `lib.contracts.newContract`.
