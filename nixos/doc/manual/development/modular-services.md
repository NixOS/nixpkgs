
# Modular Services {#modular-services}

Status: in development. This functionality is new in NixOS 25.11, and significant changes should be expected. We'd love to hear your feedback in <https://github.com/NixOS/nixpkgs/pull/372170>

Traditionally, NixOS services were defined using sets of options *in* modules, not *as* modules. This made them non-modular, resulting in problems with composability, reuse, and portability.

A configuration management framework is an application of `evalModules` with the `class` and `specialArgs` input attribute set to particular values.
NixOS is such a configuration management framework, and so are [Home Manager](https://github.com/nix-community/home-manager) and [`nix-darwin`](https://github.com/lnl7/nix-darwin).

The service management component of a configuration management framework is the set of module options that connects Nix expressions with the underlying service (or process) manager.
For NixOS this is the module wrapping [`systemd`](https://systemd.io/), on `nix-darwin` this is the module wrapping [`launchd`](https://en.wikipedia.org/wiki/Launchd).

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
{
  system.services.my-service-instance = {
    imports = [ pkgs.some-application.services.some-service-module ];
    foo.settings = {
      # ...
    };
  };
}
```

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

## Portable Service Options {#modular-service-options-portable}

```{=include=} options
id-prefix: service-opt-
list-id: service-options
source: @PORTABLE_SERVICE_OPTIONS@
```

## Systemd-specific Service Options {#modular-service-options-systemd}

```{=include=} options
id-prefix: systemd-service-opt-
list-id: systemd-service-options
source: @SYSTEMD_SERVICE_OPTIONS@
```

[module]: https://nixos.org/manual/nixpkgs/stable/index.html#module-system
<!-- TODO: more anchors -->
[`attrsOf`]: #sec-option-types-composed
[`submodule`]: #sec-option-types-submodule
