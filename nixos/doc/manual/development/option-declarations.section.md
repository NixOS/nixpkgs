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

:   The type of the option (see [](#sec-option-types)). This
    argument is mandatory for nixpkgs modules. Setting this is highly
    recommended for the sake of documentation and type checking. In case it is
    not set, a fallback type with unspecified behavior is used.

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
    included in the NixOS manual. During the migration process from DocBook
    to CommonMark the description may also be written in CommonMark, but has
    to be wrapped in `lib.mdDoc` to differentiate it from DocBook. See
    the nixpkgs manual for [the list of CommonMark extensions](
    https://nixos.org/nixpkgs/manual/#sec-contributing-markup)
    supported by NixOS documentation.

    New documentation should preferably be written as CommonMark.

## Utility functions for common option patterns {#sec-option-declarations-util}

### `mkEnableOption` {#sec-option-declarations-util-mkEnableOption}

Creates an Option attribute set for a boolean value option i.e an
option to be toggled on or off.

This function takes a single string argument, the name of the thing to be toggled.

The option's description is "Whether to enable \<name\>.".

For example:

::: {#ex-options-declarations-util-mkEnableOption-magic .example}
```nix
lib.mkEnableOption "magic"
# is like
lib.mkOption {
  type = lib.types.bool;
  default = false;
  example = true;
  description = "Whether to enable magic.";
}
```

### `mkPackageOption` {#sec-option-declarations-util-mkPackageOption}

Usage:

```nix
mkPackageOption pkgs "name" { default = [ "path" "in" "pkgs" ]; example = "literal example"; }
```

Creates an Option attribute set for an option that specifies the package a module should use for some purpose.

**Note**: You shouldn’t necessarily make package options for all of your modules. You can always overwrite a specific package throughout nixpkgs by using [nixpkgs overlays](https://nixos.org/manual/nixpkgs/stable/#chap-overlays).

The default package is specified as a list of strings representing its attribute path in nixpkgs. Because of this, you need to pass nixpkgs itself as the first argument.

The second argument is the name of the option, used in the description "The \<name\> package to use.". You can also pass an example value, either a literal string or a package's attribute path.

You can omit the default path if the name of the option is also attribute path in nixpkgs.

::: {#ex-options-declarations-util-mkPackageOption .title}
Examples:

::: {#ex-options-declarations-util-mkPackageOption-hello .example}
```nix
lib.mkPackageOption pkgs "hello" { }
# is like
lib.mkOption {
  type = lib.types.package;
  default = pkgs.hello;
  defaultText = lib.literalExpression "pkgs.hello";
  description = "The hello package to use.";
}
```

::: {#ex-options-declarations-util-mkPackageOption-ghc .example}
```nix
lib.mkPackageOption pkgs "GHC" {
  default = [ "ghc" ];
  example = "pkgs.haskell.packages.ghc924.ghc.withPackages (hkgs: [ hkgs.primes ])";
}
# is like
lib.mkOption {
  type = lib.types.package;
  default = pkgs.ghc;
  defaultText = lib.literalExpression "pkgs.ghc";
  example = lib.literalExpression "pkgs.haskell.packages.ghc924.ghc.withPackages (hkgs: [ hkgs.primes ])";
  description = "The GHC package to use.";
}
```

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

There are two approaches we could take with this module structure:

-   Configuring the display managers independently by adding an enable
    option to every display manager module backend. (NixOS)

-   Configuring the display managers in the central module by adding
    an option to select which display manager backend to use.

Both approaches have problems.

Making backends independent can quickly become hard to manage. For
display managers, there can only be one enabled at a time, but the
type system cannot enforce this restriction as there is no relation
between each backend's `enable` option. As a result, this restriction
has to be done explicitly by adding assertions in each display manager
backend module.

On the other hand, managing the display manager backends in the
central module will require changing the central module option every
time a new backend is added or removed.

By using extensible option types, it is possible to create a placeholder
option in the central module
([Example: Extensible type placeholder in the service module](#ex-option-declaration-eot-service)),
and to extend it in each backend module
([Example: Extending `services.xserver.displayManager.enable` in the `gdm` module](#ex-option-declaration-eot-backend-gdm),
[Example: Extending `services.xserver.displayManager.enable` in the `sddm` module](#ex-option-declaration-eot-backend-sddm)).

As a result, `displayManager.enable` option values can be added without
changing the main service module file and the type system automatically
enforces that there can only be a single display manager enabled.

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
