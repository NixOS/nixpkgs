
# Modular Services {#modular-services}

Status: in development. This functionality is new in release 25.11, and significant changes should be expected.
We'd love to hear your feedback in in our [matrix channel](https://matrix.to/#/#modular-services:nixos.org)
or at the [tracking issue](https://github.com/NixOS/nixpkgs/issues/428084).

Traditionally, NixOS services were defined using sets of options *in* modules, not *as* modules. This made them non-modular, resulting in problems with composability, reuse, and portability.

A configuration management framework is an application of `evalModules` with the `class` and `specialArgs` input attribute set to particular values.
NixOS is such a configuration management framework, and so are [Home Manager](https://github.com/nix-community/home-manager) and [`nix-darwin`](https://github.com/nix-darwin/nix-darwin).

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
