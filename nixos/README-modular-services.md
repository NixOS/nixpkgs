
# Writing and Reviewing Modular Services

## Status

Modular Services are, as of writing, a new feature with support in NixOS.
It is in development, and be considerate of the fact that the intermediate outcome of RFC 163 is that we should try a module-based approach to portable services; it is not yet a widely agreed upon solution.

## Relation to NixOS Modules

- A modular service is not a replacement for a NixOS module, but may be in the future.
- Using a modular service to implement a NixOS module is an expected use case, but exposes the NixOS module to a degree of uncertainty that is not acceptable for widely used modules yet.

## Maintainership

If you contribute a modular service, you must mark yourself as maintainer of the modular service.
The maintainership of a modular service does not need to be the same as the maintainership of a NixOS module.
If you are not a maintainer of the NixOS module, you should offer to join the NixOS module's `meta.maintainers` team, so that you are included in reviews and discussions, most of which also affect the modular service.
The NixOS module maintainers have no obligation towards the modular service, except perhaps to notify you if they notice that the modular service breaks.

## Minimum Standard

Modular services **MUST** be accompanied by a **NixOS VM test** that exercises the modular service.

Modular services **MUST** have a `meta.maintainers` module attribute that lists the maintainers of the modular service.

## Reviewing Modular Services

When reviewing a modular service, you should check the following. Details and rationale are provided below.

```markdown
- [ ] Has a NixOS VM test
- [ ] Has a `meta.maintainers` attribute
- [ ] Systemd-specific definitions are behind `optionalAttrs (options ? systemd)` to promote portability.
- [ ] `_class = "service"`
- [ ] Modular services provided through `passthru.services` must override the default of the package option using `finalAttrs.finalPackage`
- [ ] Is the modular services infrastructure sufficient for this service? If one or more features are not covered, comment in https://github.com/NixOS/nixpkgs/issues/428084
```

## Details

### NixOS VM test

See the initial [Modular Services PR](https://github.com/NixOS/nixpkgs/pull/372170) for an [example](https://github.com/NixOS/nixpkgs/pull/372170/files#diff-e7fe16489cf3cd08ecc22b2c7896039d407a329b75691c046c95447423b3153f) of a NixOS VM test.
TBD: describe best practices here.

### `_class = "service"`

A [`_class`](https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules-param-class) declaration ensures a clear error when the module is accidentally imported into a configuration that isn't a modular service, such as a NixOS configuration.

Provide it as the first attribute in the module:

```nix
# Non-module dependencies (`importApply`)
{ writeScript, runtimeShell }:

# Service module
{ lib, config, ... }:
{
  _class = "service";

  options = {
    # ...
  };
  config = {
    # ...
  };
}
```

### Overriding the package default

When a modular service is provided through `passthru.services`, it must override the default of the package option using [`finalAttrs.finalPackage`](https://nixos.org/manual/nixpkgs/unstable/#mkderivation-recursive-attributes).
If this is not possible, or if the module is not represented by a single package, consider exposing the modular service directly by file path only.

Otherwise, since some packages are *defined* by an override, the modular service would launch a wrong package, if it builds at all.

Example:

`package.nix`
```nix
{
  stdenv,
  nixosTests,
# ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "example";
  # ...

  passthru = {
    services = {
      default = {
        imports = [ (lib.modules.importApply ./service.nix { inherit pkgs; }) ];
        example.package = finalAttrs.finalPackage;
        # ...
      };
    };
  };
})
```
