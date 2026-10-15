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

Example, a simplified version of the provider option `testing.hardcoded-secret.fileSecrets`:

```nix
{
  options.testing.hardcoded-secret.fileSecrets = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          imports = [ lib.contracts.fileSecrets.interface ];
          options.response = lib.mkOption {
            default = { };
            type = lib.types.submodule {
              options.path = lib.mkOption { default = "${cfg.directory}/${name}"; };
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
Each contract type has `meta.description`, `meta.maintainers` and an `interface` module.

The option [](#opt-contractTypes) contains the contract types that a configuration can use.
In NixOS, it contains each contract type in `lib.contracts`.
For each contract type, [](#opt-contracts) has an option with its `meta.description`, and with its `request` and `response` options under `want`.
To add a contract type, write its `meta` and `interface` in a new file in `lib/contracts/definitions`, and add that file to `lib/contracts/definitions/default.nix`.

The routing module is `lib.contract.module`.
It does not depend on NixOS, so other module systems can also import it.

## Route requests to a provider {#contracts-routing}

For each contract type, [](#opt-contracts) sends the requests of consumers to a provider, and sends the responses back:

- `contracts.<type>.want.<name>`: an entry with a `request` from a consumer.
  Each name must be unique for all consumers, for example `<consumer>-<option>`.
- `contracts.<type>.providers.<provider>`: where to find the *provider option*, the option of the provider that has an entry for each request that the provider fulfills.
  `module` is the options of the provider, and `contract` is the path of the provider option in `module`.
- `contracts.<type>.defaultProvider`: the provider that gets the requests, one of `providers`.
- `contracts.<type>.instances.<name>`: the provider that gets the entry `<name>` of `want`.
  The default is `defaultProvider`.
- `contracts.<type>.providerRequests.<provider>`: the requests that a provider must fulfill.
  These are the entries of `want` that `instances` sends to the provider, and `{ }` for providers not routed to fulfill requests.
- `contracts.<type>.results.<name>`: the `response` from the provider in `instances` for each entry in `want`.

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

  config.contracts.fileSecrets.want.stash-passwordFile = {
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
  services.stash.passwordFile.response = config.contracts.fileSecrets.results.stash-passwordFile;
  testing.hardcoded-secret.fileSecrets.stash-passwordFile.providerOptions.content = "MyPassword";
}
```

To use a different provider, change `defaultProvider`, and set the options of that provider.

To send one entry to a different provider, set `instances.<name>` to that provider:

```nix
{ config, ... }:
{
  contracts.fileSecrets.instances.stash-passwordFile =
    config.contracts.fileSecrets.providers.other-provider;
}
```

To connect one entry manually, as in [](#contracts-connect), set `instances.<name>` to `null`.
Then no provider gets the request of that entry from `providerRequests`, and `results.<name>` is not available.
