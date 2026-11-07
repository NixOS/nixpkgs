
# Generic {#modules-generic}

Generic modules can be imported to extend configurations of any [class].

## `meta-maintainers.nix` {#modules-generic-meta-maintainers}

The options below become available when using `imports = [ (nixpkgs + "/modules/generic/meta-maintainers.nix") ];`.

```{=include=} options
id-prefix: opt-modules-generic-meta-maintainers-
list-id: configuration-variable-list
source: ../options-modules-generic-meta-maintainers.json
```

## Modules of a package {#modules-generic-pkgs}

`modules/generic/pkgs/by-name/<shard>/<package>` has the generic modules of a package.
Thus NixOS, modular services and systems outside of Nixpkgs can share them, and the sandbox that builds the NixOS manual contains them.

A file in `pkgs/by-name` must not refer to a path outside of its package directory (`nixpkgs-vet` check NPV-123).
Thus a package gets its modules from the `path` argument of `callPackage`:

```nix
path + "/modules/generic/pkgs/by-name/my/my-program"
```

### Configuration files {#modules-generic-pkgs-config-files}

`config-files.nix` has the inputs of `pkgs.configFiles`, and refers to `config-module.nix`, which has the options of the program.
`pkgs.configFiles` evaluates these modules. `portable.files` has the configuration files, and `portable.directory` is a directory that holds them.
The package exposes the result as `passthru.configFiles`, and the file of the program as `passthru.configModule`.

`config-module.nix` must work where no `pkgs` module argument exists, for example in a modular service.
Thus it is a function that takes the packages that it needs and returns a module, as `service.nix` of a modular service is:

```nix
{ formats }:

{ config, lib, ... }:
let
  format = formats.ini { };
in
{
  # ...
}
```

`config-files.nix` puts this file in `moduleFiles`, and `pkgs.configFiles` gets the arguments from `pkgs`.

A NixOS module imports `config-files.nix` by path, not from the attribute of the package, because the sandbox that builds the option documentation has no packages.
For example, `nixos/modules/services/hardware/lact.nix` imports `la/lact/config-files.nix`.
See `pkgs.configFiles` in `pkgs/pkgs-lib/config-files.nix`.

### `settings` {#modules-generic-pkgs-settings}

As [RFC 42](https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md) specifies, an option named `settings` has the contents of a configuration file.
For example, `services.lact.settings` has the contents of the configuration file of `lact`.

[class]: https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules-param-class
