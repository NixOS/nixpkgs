
# Modular Services {#modular-services}

Status: in development. This functionality is new in release 25.11, and significant changes should be expected.
We'd love to hear your feedback in in our [matrix channel](https://matrix.to/#/#modular-services:nixos.org)
or at the [tracking issue](https://github.com/NixOS/nixpkgs/issues/428084).

## Portability {#modular-service-portability}

It is possible to write service modules that are portable. This is done by either avoiding the `systemd` option tree, or by defining process-manager-specific definitions in an optional way:

```nix
{
  config,
  options,
  lib,
  ...
}:
{
  _class = "service";
  config = {
    process.argv = [ (lib.getExe config.foo.program) ];
  }
  // lib.optionalAttrs (options ? systemd) {
    # ... systemd-specific definitions ...
  };
}
```

This way, the module can be loaded into a configuration manager that does not use systemd, and the `systemd` definitions will be ignored.
Similarly, other configuration managers can declare their own options for services to customize.

## Composition and Ownership {#modular-service-composition}

Compared to traditional services, modular services are inherently more composable, by virtue of being modules and receiving a user-provided name when imported.
However, composition can not end there, because services need to be able to interact with each other.
This can be achieved in two ways:
1. Users can link services together by providing the necessary NixOS configuration.
2. Services can be compositions of other services.

These aren't mutually exclusive. In fact, it is a good practice when developing services to first write them as individual services, and then compose them into a higher-level composition. Each of these services is a valid modular service, including their composition.

## Migration {#modular-service-migration}

Many services could be migrated to the modular service system, but even when the modular service system is mature, it is not necessary to migrate all services.
For instance, many system-wide services are a mandatory part of a desktop system, and it doesn't make sense to have multiple instances of them.
Moving their logic into separate Nix files may still be beneficial for the efficient evaluation of configurations that don't use those services, but that is a rather minor benefit, unless modular services potentially become the standard way to define services.

<!-- TODO example of a single-instance service -->

## Writing and Reviewing a Modular Service {#modular-service-review}

A typical service module consists of the following:

For more details, refer to the contributor documentation in [`nixos/README-modular-services.md`](https://github.com/NixOS/nixpkgs/blob/master/nixos/README-modular-services.md).

