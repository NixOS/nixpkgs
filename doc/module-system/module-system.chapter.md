
# Module System {#module-system}

## Introduction {#module-system-introduction}

The module system is a language for handling configuration, implemented as a Nix library.

It extends plain Nix values with the following aspects:

 - Merging separate configuration values into one
 - Runtime type checking
 - Documentation

From these aspects, use cases emerge:

 - Reusable modules that embody configuration knowledge
 - Separation of concerns, separation into files

It was originally written with the goal of supporting NixOS, but numerous other configuration systems use it too.

## Module Evaluation {#module-system-evaluation}

The core responsibility of the module system is to turn a list of modules into a single configuration. This is implemented by the [`evalModules`](#fun-evalModules) function and its dependencies.

The process can be thought of as follows.

 - take the raw module expressions,
 - unify the module syntax,
 - unify the module syntax of `imports`
 - merge the option declarations
 - merge the config definitions
 - return the configuration, metadata and extension method

However, because Nix is a lazy language, the control flow is more flexible than that, allowing more information to be accessed, that would not be possible in a strictly sequential process.

Oversimplifying, this code captures the essence of `config`: a fixed point.

```nix
let module = config: { a = config.b; b = 1; };
    evalModule = f: let x = f x; in x;
in evalModule module
```

## Module Unification {#module-system-module-unification}

A module can be represented by multiple syntaxes. The most basic syntax is that of a shorthand module, which is just an attribute set of configuration values.

Example:

```nix
{
  foo = {
    enable = true;
  };
}
```

Because this attribute set does not contain the attributes `config` or `options` in its attributes, this is translated internally to:

```nix
{ ... }: {
  config = {
    foo = {
      enable = true;
    };
  };
}
```

## Module `imports` Resolution

TBD

## Module Option Declaration Merging

TBD

## Module Config Value Merging

TBD



```{=docbook}
<xi:include xmlns:xi="http://www.w3.org/2001/XInclude" href="reference.section.xml" />
```

