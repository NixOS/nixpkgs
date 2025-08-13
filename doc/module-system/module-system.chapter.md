# Module System {#module-system}

## Introduction {#module-system-introduction}

The module system is a language for handling configuration, implemented as a Nix library.

Compared to plain Nix, it adds documentation, type checking and composition or extensibility.

::: {.note}
This chapter is new and not complete yet.

See also:
- Introduction to the module system, in the context of NixOS, see [Writing NixOS Modules](https://nixos.org/manual/nixos/unstable/index.html#sec-writing-modules) in the NixOS manual.
- Generic guide to the module system on [nix.dev](https://nix.dev/tutorials/module-system/index.html).
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

::: {.warning}
You may be tempted to use `specialArgs.lib` to provide extra library functions. Doing so limits the interoperability of modules, as well as the interoperability of Module System applications.

`lib` is reserved for the Nixpkgs library, and should not be used for custom functions.

Instead, you may create a new attribute in `specialArgs` to provide custom functions.
This clarifies their origin and avoids incompatibilities.
:::

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

#### `graph` {#module-system-lib-evalModules-return-value-graph}

Represents all the modules that took part in the evaluation.
It is a list of `ModuleGraph` where `ModuleGraph` is defined as an attribute set with the following attributes:

- `key`: `string` for the purpose of module deduplication and `disabledModules`
- `file`: `string` for the purpose of error messages and warnings
- `imports`: `[ ModuleGraph ]`
- `disabled`: `bool`

## Module arguments {#module-system-module-arguments}

Module arguments are the attribute values passed to modules when they are evaluated.

They originate from these sources:
1. Built-in arguments
    - `lib`,
    - `config`,
    - `options`,
    - `_class`,
    - `_prefix`,
2. Attributes from the [`specialArgs`] argument passed to [`evalModules`] or `submoduleWith`. These are application-specific.
3. Attributes from the `_module.args` option value. These are application-specific and can be provided by any module.

The prior two categories are available while evaluating the `imports`, whereas
the last category is only available after the `imports` have been resolved.

[`lib`]{#module-system-module-argument-lib} [🔗](#module-system-module-argument-lib)
: A reference to the Nixpkgs library.

[`config`]{#module-system-module-argument-config} [🔗](#module-system-module-argument-config)
: All option values.
  Unlike the `evalModules` [`config` return attribute](#module-system-lib-evalModules-return-value-config), this includes `_module`.

[`options`]{#module-system-module-argument-options} [🔗](#module-system-module-argument-options)
: All evaluated option declarations.

[`_class`]{#module-system-module-argument-_class} [🔗](#module-system-module-argument-_class)
: The [expected class](#module-system-lib-evalModules-param-class) of the loaded modules.

[`_prefix`]{#module-system-module-argument-_prefix} [🔗](#module-system-module-argument-_prefix)
: The location under which the module is evaluated.
  This is used to improve error reporting and to find the implicit `name` module argument in submodules.
  It is exposed as a module argument due to how the module system is implemented, which cannot be avoided without breaking compatibility.

  It is a good practice not to rely on `_prefix`. A module should not make assumptions about its location in the configuration tree.
  For example, the root of a NixOS configuration may have a non-empty prefix, for example when it is a specialisation, or when it is part of a larger, multi-host configuration such as a [NixOS test](https://nixos.org/manual/nixos/unstable/#sec-nixos-tests).
  Instead of depending on `_prefix` use explicit options, whose default definitions can be provided by the module that imports them.

<!-- markdown link aliases -->
[`evalModules`]: #module-system-lib-evalModules
[`specialArgs`]: #module-system-lib-evalModules-param-specialArgs
