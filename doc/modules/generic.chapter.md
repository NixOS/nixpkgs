
# Generic {#modules-generic}

Generic modules can be imported to extend configurations of any [class].

## `meta-maintainers.nix` {#modules-generic-meta-maintainers}

The options below become available when using `imports = [ (nixpkgs + "/modules/generic/meta-maintainers.nix") ];`.

```{=include=} options
id-prefix: opt-modules-generic-meta-maintainers-
list-id: configuration-variable-list
source: ../options-modules-generic-meta-maintainers.json
```

## `lib.genericModules.command-line` {#modules-generic-command-line}

This module has the options to construct argument strings for a given program.
A module of a program sets `flags` from the options of the program, and a consumer reads `argv`.

The module takes a `prefix` argument through `lib.modules.importApply`, which is the attribute path of the options:
- Modular services use `[ "process" ]`, thus `process.argv`.
- The modules of a package use `[ "portable" ]`, thus `portable.argv`.

The options below have the prefix `portable`.

```{=include=} options
id-prefix: opt-modules-generic-command-line-
list-id: configuration-variable-list
source: ../options-modules-generic-command-line.json
```

## Modules of a package {#modules-generic-pkgs}

`modules/generic/pkgs/by-name/<shard>/<package>` has the generic modules of a package.
Thus NixOS, modular services and systems outside of Nixpkgs can share them, and the sandbox that builds the NixOS manual contains them.

A file in `pkgs/by-name` must not refer to a path outside of its package directory (`nixpkgs-vet` check NPV-123).
Thus a package gets its modules from the `path` argument of `callPackage`:

```nix
path + "/modules/generic/pkgs/by-name/my/my-program"
```

A module in this directory imports `lib/modules/generic` by a relative path, not from `lib.genericModules`.
The reason is that the `lib` module argument can come from a different Nixpkgs version.
For example, a NixOS configuration can import `pkgs.ghostunnel.services.default` from a newer `pkgs`.

### Commands {#modules-generic-pkgs-commands}

`commands/<program>.nix` has the options of a program.
`commands/<program>/<subcommand>.nix` has the options of a subcommand, and imports the module of its program.
Deeper subcommands continue this pattern.
For example, `gh/ghostunnel/commands/ghostunnel/server.nix` is for `ghostunnel server`, and imports `gh/ghostunnel/commands/ghostunnel.nix`, which has the options that all subcommands share.

These modules use [`lib.genericModules.command-line`](#modules-generic-command-line) with the prefix `[ "portable" ]`.
The module of a program selects the program from its `package` option.
Thus a consumer sets only `package`, also for a package with more than one program.

In `portable.argv`:
- The flags of a program use `lib.mkBefore`, thus they come before the subcommand.
- A subcommand has the default priority, and its flags come after it.
- A nested subcommand uses `lib.mkOrder` to come after the flags of its parent.

`passthru.commandModules` is the tree that `lib.modules.commandTree` makes from `commands`.
Each node is a module that sets `package`, and its `commands` attribute has a node for each subcommand.
For example, `pkgs.ghostunnel.commandModules.ghostunnel.commands.server` is for `ghostunnel server`:

```nix
(lib.evalModules {
  modules = [
    pkgs.ghostunnel.commandModules.ghostunnel.commands.server
    {
      listen = "0.0.0.0:443";
      target = "localhost:80";
      # ...
    }
  ];
}).config.portable.argv
```

A consumer can use `pkgs.ghostunnel.commandModules.ghostunnel` to add a subcommand that has no module.
A consumer can import a node together with its subcommands.

To let a user select one subcommand, a consumer can use `types.attrTag`:

```nix
{ lib, pkgs, ... }:
{
  options.tunnel = lib.mkOption {
    type = lib.types.attrTag (
      lib.mapAttrs (
        name: module:
        lib.mkOption {
          description = "Run `wstunnel ${name}`.";
          type = lib.types.submodule module;
        }
      ) pkgs.wstunnel.commandModules.wstunnel.commands
    );
  };
}
```

Then `(lib.head (lib.attrValues config.tunnel)).portable.argv` is the command line.

### `settings` {#modules-generic-pkgs-settings}

As [RFC 42](https://github.com/NixOS/rfcs/blob/master/rfcs/0042-config-option.md) specifies, an option named `settings` has the contents of a configuration file.
Thus a module sets flags from an option with a different name, or from `portable.flags`.
For example, `services.litellm.settings` has the contents of the configuration file of `litellm`, and the NixOS module sets `portable.flags.config` to that file.

In `wstunnel`, `settings` has flags, to keep the paths of the options of `services.wstunnel`.

[class]: https://nixos.org/manual/nixpkgs/unstable/#module-system-lib-evalModules-param-class
