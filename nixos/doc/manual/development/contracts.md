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
For the `request` and `response` options of a contract type and the behavior of a provider, refer to the options of the provider, for example [](#opt-testing.hardcoded-secret.fileSecrets).

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
