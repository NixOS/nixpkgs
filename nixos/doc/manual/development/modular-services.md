
# Modular Services {#modular-services-nixos}

Status: in development. This functionality is new in release 25.11, and significant changes should be expected.
We'd love to hear your feedback in in our [matrix channel](https://matrix.to/#/#modular-services:nixos.org)
or at the [tracking issue](https://github.com/NixOS/nixpkgs/issues/428084).

Modular services are a framework for defining portable, composable NixOS services as modules.
For the main documentation on these, see the [nixpkgs manual](https://nixos.org/manual/nixpkgs/unstable/#modular-services).

A configuration management framework is an application of `evalModules` with the `class` and `specialArgs` input attribute set to particular values.
NixOS is such a configuration management framework, and so are [Home Manager](https://github.com/nix-community/home-manager) and [`nix-darwin`](https://github.com/nix-darwin/nix-darwin).

On NixOS, modular services are wired into `systemd` via `system.services.<name>`.
That option has type [`attrsOf`] [`submodule`], where the `submodule` is pre-loaded with:
- a generic portable module
- a module with systemd-specific options whose values or defaults derive from the generic module.

For example:

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

For a list of modular services bundled in nixpkgs, see the [nixpkgs manual appendix](https://nixos.org/manual/nixpkgs/unstable/package-module-options.html).

## Systemd-specific Service Options {#modular-service-options-systemd}

```{=include=} options
id-prefix: systemd-service-opt-
list-id: systemd-service-options
source: @SYSTEMD_SERVICE_OPTIONS@
```
[`attrsOf`]: #sec-option-types-composed
[`submodule`]: #sec-option-types-submodule
