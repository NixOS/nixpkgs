# Option Declarations {#sec-option-declarations}

An option declaration specifies the name, type and description of a
NixOS configuration option. It is invalid to define an option that
hasn't been declared in any module. An option declaration generally
looks like this:

```nix
options = {
  name = mkOption {
    type = type specification;
    default = default value;
    example = example value;
    description = "Description for use in the NixOS manual.";
  };
};
```

The attribute names within the `name` attribute path must be camel
cased in general but should, as an exception, match the [ package
attribute name](https://nixos.org/nixpkgs/manual/#sec-package-naming)
when referencing a Nixpkgs package. For example, the option
`services.nix-serve.bindAddress` references the `nix-serve` Nixpkgs
package.

The function `mkOption` accepts the following arguments.

`type`

:   The type of the option (see [](#sec-option-types)). It may be
    omitted, but that's not advisable since it may lead to errors that
    are hard to diagnose.

`default`

:   The default value used if no value is defined by any module. A
    default is not required; but if a default is not given, then users
    of the module will have to define the value of the option, otherwise
    an error will be thrown.

`defaultText`

:   A textual representation of the default value to be rendered verbatim in
    the manual. Useful if the default value is a complex expression or depends
    on other values or packages.
    Use `lib.literalExpression` for a Nix expression, `lib.literalDocBook` for
    a plain English description in DocBook format.

`example`

:   An example value that will be shown in the NixOS manual.
    You can use `lib.literalExpression` and `lib.literalDocBook` in the same way
    as in `defaultText`.

`description`

:   A textual description of the option, in DocBook format, that will be
    included in the NixOS manual.

## Extensible Option Types {#sec-option-declarations-eot}

Extensible option types is a feature that allow to extend certain types
declaration through multiple module files. This feature only work with a
restricted set of types, namely `enum` and `submodules` and any composed
forms of them.

Extensible option types can be used for `enum` options that affects
multiple modules, or as an alternative to related `enable` options.

As an example, we will take the case of display managers. There is a
central display manager module for generic display manager options and a
module file per display manager backend (sddm, gdm \...).

There are two approach to this module structure:

-   Managing the display managers independently by adding an enable
    option to every display manager module backend. (NixOS)

-   Managing the display managers in the central module by adding an
    option to select which display manager backend to use.

Both approaches have problems.

Making backends independent can quickly become hard to manage. For
display managers, there can be only one enabled at a time, but the type
system can not enforce this restriction as there is no relation between
each backend `enable` option. As a result, this restriction has to be
done explicitely by adding assertions in each display manager backend
module.

On the other hand, managing the display managers backends in the central
module will require to change the central module option every time a new
backend is added or removed.

By using extensible option types, it is possible to create a placeholder
option in the central module
([Example: Extensible type placeholder in the service module](#ex-option-declaration-eot-service)),
and to extend it in each backend module
([Example: Extending `services.xserver.displayManager.enable` in the `gdm` module](#ex-option-declaration-eot-backend-gdm),
[Example: Extending `services.xserver.displayManager.enable` in the `sddm` module](#ex-option-declaration-eot-backend-sddm)).

As a result, `displayManager.enable` option values can be added without
changing the main service module file and the type system automatically
enforce that there can only be a single display manager enabled.

::: {#ex-option-declaration-eot-service .example}
::: {.title}
**Example: Extensible type placeholder in the service module**
:::
```nix
services.xserver.displayManager.enable = mkOption {
  description = "Display manager to use";
  type = with types; nullOr (enum [ ]);
};
```
:::

::: {#ex-option-declaration-eot-backend-gdm .example}
::: {.title}
**Example: Extending `services.xserver.displayManager.enable` in the `gdm` module**
:::
```nix
services.xserver.displayManager.enable = mkOption {
  type = with types; nullOr (enum [ "gdm" ]);
};
```
:::

::: {#ex-option-declaration-eot-backend-sddm .example}
::: {.title}
**Example: Extending `services.xserver.displayManager.enable` in the `sddm` module**
:::
```nix
services.xserver.displayManager.enable = mkOption {
  type = with types; nullOr (enum [ "sddm" ]);
};
```
:::

The placeholder declaration is a standard `mkOption` declaration, but it
is important that extensible option declarations only use the `type`
argument.

Extensible option types work with any of the composed variants of `enum`
such as `with types; nullOr (enum [ "foo" "bar" ])` or `with types;
listOf (enum [ "foo" "bar" ])`.
