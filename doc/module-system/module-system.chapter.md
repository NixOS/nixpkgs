# Module System {#module-system}

## Introduction {#module-system-introduction}

The module system is a language for handling configuration, implemented as a Nix library.

Compared to plain Nix, it adds documentation, type checking and composition or extensibility.

::: {.note}
This chapter is new and not complete yet. For a gentle introduction to the module system, in the context of NixOS, see [Writing NixOS Modules](https://nixos.org/manual/nixos/unstable/index.html#sec-writing-modules) in the NixOS manual.
:::


## `lib.evalModules` {#module-system-lib-evalModules}

Evaluate a set of modules. This function is typically only used once per application (e.g. once in NixOS, once in Home Manager, ...).

### Parameters {#module-system-lib-evalModules-parameters}

#### `modules` {#module-system-lib-evalModules-param-modules}

A list of modules. These are merged together to form the final configuration.
<!-- TODO link to section about merging, TBD -->

#### `specialArgs` {#module-system-lib-evalModules-param-specialArgs}

An attribute set of module arguments that can be used in `imports`.

This is in contrast to `config._module.args`, which is only available after all `imports` have been resolved.

#### `class` {#module-system-lib-evalModules-param-class}

If the `class` attribute is set and non-`null`, the module system will reject `imports` with a different `_class` declaration.

The `class` value should be a string in lower [camel case](https://en.wikipedia.org/wiki/Camel_case).

If applicable, the `class` should match the "prefix" of the attributes used in (experimental) [flakes](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#description). Some examples are:

 - `nixos` as in `flake.nixosModules`
 - `nixosTest`: modules that constitute a [NixOS VM test](https://nixos.org/manual/nixos/stable/index.html#sec-nixos-tests)
<!-- We've only just started with `class`. You're invited to add a few more. -->

#### `prefix` {#module-system-lib-evalModules-param-prefix}

A list of strings representing the location at or below which all options are evaluated. This is used by `types.submodule` to improve error reporting and find the implicit `name` module argument.

### Return value {#module-system-lib-evalModules-return-value}

The result is an attribute set with the following attributes:

#### `options` {#module-system-lib-evalModules-return-value-options}

The nested attribute set of all option declarations.

#### `config` {#module-system-lib-evalModules-return-value-config}

The nested attribute set of all option values.

#### `type` {#module-system-lib-evalModules-return-value-type}

A module system type. This type is an instance of `types.submoduleWith` containing the current [`modules`](#module-system-lib-evalModules-param-modules).

The option definitions that are typed with this type will extend the current set of modules, like [`extendModules`](#module-system-lib-evalModules-return-value-extendModules).

However, the value returned from the type is just the [`config`](#module-system-lib-evalModules-return-value-config), like any submodule.

If you're familiar with prototype inheritance, you can think of this `evalModules` invocation as the prototype, and usages of this type as the instances.

This type is also available to the [`modules`](#module-system-lib-evalModules-param-modules) as the module argument `moduleType`.
<!-- TODO: document the module arguments. Using moduleType is like saying: suppose this configuration was extended. -->

#### `extendModules` {#module-system-lib-evalModules-return-value-extendModules}

A function similar to `evalModules` but building on top of the already passed [`modules`](#module-system-lib-evalModules-param-modules). Its arguments, `modules` and `specialArgs` are added to the existing values.

If you're familiar with prototype inheritance, you can think of the current, actual `evalModules` invocation as the prototype, and the return value of `extendModules` as the instance.

This functionality is also available to modules as the `extendModules` module argument.

::: {.note}

**Evaluation Performance**

`extendModules` returns a configuration that shares very little with the original `evalModules` invocation, because the module arguments may be different.

So if you have a configuration that has been (or will be) largely evaluated, almost none of the computation is shared with the configuration returned by `extendModules`.

The real work of module evaluation happens while computing the values in `config` and `options`, so multiple invocations of `extendModules` have a particularly small cost, as long as only the final `config` and `options` are evaluated.

If you do reference multiple `config` (or `options`) from before and after `extendModules`, evaluation performance is the same as with multiple `evalModules` invocations, because the new modules' ability to override existing configuration fundamentally requires constructing a new `config` and `options` fixpoint.
:::

#### `_module` {#module-system-lib-evalModules-return-value-_module}

A portion of the configuration tree which is elided from `config`.

<!-- TODO: when markdown migration is complete, make _module docs visible again and reference _module docs. Maybe move those docs into this chapter? -->

#### `_type` {#module-system-lib-evalModules-return-value-_type}

A nominal type marker, always `"configuration"`.

#### `class` {#module-system-lib-evalModules-return-value-_configurationClass}

The [`class` argument](#module-system-lib-evalModules-param-class).
