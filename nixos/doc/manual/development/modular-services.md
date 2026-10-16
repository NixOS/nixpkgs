
# Modular Services {#modular-services}

Status: in development. This functionality is new in NixOS 25.11, and significant changes should be expected. We'd love to hear your feedback in <https://github.com/NixOS/nixpkgs/pull/372170>

A conventional NixOS service is a module that defines options under `systemd.services.*`. The resulting configuration is non-modular, which leads to problems with composability, reuse, and portability.

A *modular service* splits the conventional service into two parts:
- the modular service itself, which is a module that defines values for a core set of the service's options, like processes and config files, in a service manager-agnostic way;
- a configuration management framework, which consumes the modular service and turns those "abstract" options into service-manager specific ones.

A configuration management framework is an application of `evalModules` with the `class` and `specialArgs` input attribute set to particular values. NixOS is such a configuration management framework, and so are [Home Manager](https://github.com/nix-community/home-manager) and [nix-darwin](https://github.com/nix-darwin/nix-darwin).

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

## Identity {#modular-service-identity}

Modular services have `identity.*` options for running a service as a specific user or group.
The option values are *requests*: on platforms that support users, the service manager resolves them to the real values (the user name, its uid, and groups) when the values are read; on platforms without user support, they resolve to `null`.

By default, each service gets its own user on platforms that support users.
The user's name is derived from the service's attribute path, and the uid/gid is allocated by the platform (e.g. NixOS picks a free uid at activation).
The primary group defaults to a user-private group named after the user.

To run services under a shared user without pinning names or ids, set `identity.sameUser` on a service to another service's *configuration*, which serves as a reference to it:

```nix
{
  system.services.my-app = { config, ... }: {
    # imports = [ ... ];
    services.web = {
      # Run the web instance as the worker sub-service's user.
      identity.sameUser = config.services.example-2;
    };
    # services.api.settings = {
    #
    # };
  };
}
```

Because the reference is the target service's configuration itself, such code is reusable regardless of where the composite module is imported; no service attribute paths have to be spelled out:

```nix
# my-composite-service.nix
{ config, ... }: {
  services.foo = {
    imports = [ ./foo.nix ];
  };
  services.bar = {
    imports = [ ./bar.nix ];
    identity.sameUser = config.services.foo;
  };
}
```

This works because the service manager (here: NixOS's systemd integration, `nixos/modules/system/service/systemd/identity.nix`) injects a built-in, read-only `absoluteServicePath` option on every service, turning each service configuration into a referenceable handle.
The referenced service's resolved identity is used for the referencing service.

Alternatively, a composing service can anchor the shared user on one of its sub-services:

```nix
{
  system.services.my-app = { config, ... }: {
    # imports = [ ... ];

    # Run my-app itself as the same user as its `worker` sub-service.
    identity.sameUser = config.services.worker;
    services.worker.settings = {
      #...
    };
  };
}
```

Names and ids can be pinned at any granularity:

```nix
{
  system.services.my-app.identity = {
    user = "my-app";
    uid = 300;
    group = "my-app";
    gid = 300;
    groups = [ "www-data" ];
    gids = [ 33 ];
  };
}
```

Each option can be pinned independently, such as only `identity.uid` while the name is still derived from the attribute path.

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
[`attrsOf`]: https://nixos.org/manual/nixpkgs/unstable/#function-library-lib.types.attrsOf
[`submodule`]: https://nixos.org/manual/nixpkgs/unstable/#function-library-lib.types.submodule
