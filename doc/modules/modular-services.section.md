
# Modular Services {#modular-services}

Status: in development. This functionality is new in release 25.11, and significant changes should be expected.
We'd love to hear your feedback in in our [matrix channel](https://matrix.to/#/#modular-services:nixos.org)
or at the [tracking issue](https://github.com/NixOS/nixpkgs/issues/428084).

In NixOS, services were traditionally defined using sets of options *in* modules, not *as* modules. This made them non-modular, resulting in problems with composability, reuse, and portability.

A configuration management framework is an application of `evalModules` with the `class` and `specialArgs` input attribute set to particular values.
NixOS is such a configuration management framework, and so are [Home Manager](https://github.com/nix-community/home-manager),
[`nimi`](https://github.com/weyl-ai/nimi) and [`finix`](https://github.com/finix-community/finix).

The service management component of a configuration management framework is the set of module options that connects Nix expressions with the underlying service (or process) manager.
For NixOS this is the module wrapping [`systemd`](https://systemd.io/), on `finix` this is the module wrapping [`finit`](https://github.com/finit-project/finit), and so on for additional service (or process) managers.

A *modular service* is a [module] that defines values for a core set of options declared in the service management component of a configuration management framework, including which program to run.
Since it's a module, it can be composed with other modules via `imports` to extend its functionality.

NixOS provides two options into which such modules can be plugged:

- `system.services.<name>`
- an option for user services (TBD)

Crucially, these options have the type [`attrsOf`] [`submodule`].
The name of the service is the attribute name corresponding to `attrsOf`.
<!-- ^ This is how composition is *always* provided, instead of a difficult thing (but this is reference docs, not a changelog) -->
The `submodule` is pre-loaded with two modules:
- a generic module that is intended to be portable
- a module with systemd-specific options, whose values or defaults derive from the generic module's option values.

So note that the default value of `system.services.<name>` is not a complete service. It requires that the user provide a value, and this is typically done by importing a module. For example:

<!-- Not using typical example syntax, because reading this is *not* optional, and should it should not be folded closed. -->
```nix
{ pkgs, ... }:
{
  system.services.my-service-instance = {
    imports = [ pkgs.some-application.services.some-service-module ];
    foo.settings = {
      # ...
    };
  };
}
```

For NixOS-specific integration (systemd), see the [NixOS manual](https://nixos.org/manual/nixos/unstable/#modular-services-nixos).

## Motivation {#modular-service-motivation}

Traditionally a NixOS service is a set of options *in* a module: one module declares `services.foo.*`, there is exactly one instance of it, and its name is fixed by whoever wrote the module.
Such a service cannot be instantiated twice, cannot be extended without patching the module that declares it, and cannot be used outside NixOS.

A modular service is a module *as* a service, which makes it:

- **instantiable** more than once, under a name you choose, by importing it at `system.services.<name>`;
- **extensible**, by importing further modules alongside it rather than editing it;
- **composable**, since a service can contain sub-services of its own -- see [](#modular-service-composition);
- **portable** across configuration management frameworks that declare the same core options -- see [](#modular-service-portability).

This is also the answer to "why not just ship a systemd unit file".
A unit file describes one service, for one service manager, in a format with no notion of options, types, defaults, or merging; it cannot be parameterized, imported twice under different names, or extended without editing it.
A modular service is a module that *produces* such a unit, and going through the module system is what buys the four properties above.
systemd-specific escapes remain available through the `systemd` option tree, guarded as shown in [](#modular-service-portability).

The portable option set is still small, as we try to find reusable abstractions.
It describes how to start the service (`process.argv`), optionally how to reload it (`process.reloadSignal`, `process.reloadCommand`, and `configData` for files whose contents may change without a restart), and how the service signals readiness (`notificationProtocol`).
Everything else -- ordering, dependencies, restart policy, isolation -- is left to the service manager, and on NixOS is reached through the `systemd` options.

## Portability {#modular-service-portability}

It is possible to write service modules that are portable.
This is done by either avoiding the `systemd` option tree, or by defining process-manager-specific definitions in an optional way.

A module that only defines portable options is portable, but requires some translation layer to be picked up by a service manager:

```nix
# Non-module dependencies (`importApply`)
{ pkgs }:

# Service module
{ config, lib, ... }:
let
  cfg = config.foo;
  format = pkgs.formats.toml { };
in
{
  _class = "service";

  options.foo = {
    package = lib.mkPackageOption pkgs "foo" { };
    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = "Configuration for `foo`, rendered to `foo.toml`.";
    };
  };

  config.process.argv = [
    (lib.getExe cfg.package)
    "--config"
    (format.generate "foo.toml" cfg.settings)
  ];
}
```

You can define process-manager-specific definitions in an optional way like:

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

For more details, refer to the contributor documentation in [`nixos/README-modular-services.md`](https://github.com/NixOS/nixpkgs/blob/master/nixos/README-modular-services.md).

## Modular Service Options {#modular-service-options}

```{=include=} options
id-prefix: service-opt-
list-id: service-options
source: ../modular-services-portable-options.json
```

[module]: #module-system
<!-- TODO: more anchors -->
[`attrsOf`]: https://nixos.org/manual/nixos/unstable/#sec-option-types-composed
[`submodule`]: https://nixos.org/manual/nixos/unstable/#sec-option-types-submodule
