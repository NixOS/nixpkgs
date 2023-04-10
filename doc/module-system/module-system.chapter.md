# Module System {#module-system}

## Introduction {#module-system-introduction}

The module system is a language for handling configuration, implemented as a Nix library.

Compared to plain Nix, it adds documentation, type checking and composition or extensibility.

NOTE: This chapter is new and not complete yet. For a gentle introduction to the module system, in the context of NixOS, see [Writing NixOS Modules](https://nixos.org/manual/nixos/unstable/index.html#sec-writing-modules) in the NixOS manual.

## `lib.evalModules` {#module-system-lib-evalModules}

Evaluate a set of modules.  The result is a set with the attributes:

### Parameters {#module-system-lib-evalModules-parameters}

#### `modules` {#module-system-lib-evalModules-param-modules}

A list of modules. These are merged together using various methods to form the final configuration.

#### `specialArgs` {#module-system-lib-evalModules-param-specialArgs}

An attribute set of module arguments that can be used in `imports`.

This is in contrast to `config._module.args`, which is only available within the module fixpoint, which does not exist before all imports are resolved.

#### `specialArgs.class` {#module-system-lib-evalModules-param-specialArgs-class}

If the `class` attribute is set in `specialArgs`, the module system will rejected modules with a different `class`.

This improves the error message that users will encounter when they import an incompatible module that was designed for a different class of configurations.

The `class` value should be in camelcase, and, if applicable, it should match the prefix of the attributes used in (experimental) flakes. Some examples are:

 - `nixos`: NixOS modules
 - `nixosTest`: modules that constitute a [NixOS VM test](https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests)

#### `prefix` {#module-system-lib-evalModules-param-prefix}

A list of strings representing the location at or below which all options are evaluated. This is used by `types.submodule` to improve error reporting and find the implicit `name` module argument.

### Return value {#module-system-lib-evalModules-return-value}

#### `options` {#module-system-lib-evalModules-return-value-options}

The nested set of all option declarations.

#### `config` {#module-system-lib-evalModules-return-value-config}

The nested set of all option values.

#### `type` {#module-system-lib-evalModules-return-value-type}

A module system type representing the module set as a submodule, to be extended by configuration from the containing module set.

This is also available as the module argument `moduleType`.

#### `extendModules` {#module-system-lib-evalModules-return-value-extendModules}

A function similar to `evalModules` but building on top of the module set. Its arguments, `modules` and `specialArgs` are added to the existing values.

Using `extendModules` a few times has no performance impact as long as you only reference the final `options` and `config`.
If you do reference multiple `config` (or `options`) from before and after `extendModules`, performance is the same as with multiple `evalModules` invocations, because the new modules' ability to override existing configuration fundamentally requires a new fixpoint to be constructed.

This is also available as a module argument.

#### `_module` {#module-system-lib-evalModules-return-value-_module}

A portion of the configuration tree which is elided from `config`. It contains some values that are mostly internal to the module system implementation.
