# Overriding {#chap-overrides}

Sometimes one wants to override parts of `nixpkgs`, e.g. derivation attributes, the results of derivations.

These functions are used to make changes to packages, returning only single packages. [Overlays](#chap-overlays), on the other hand, can be used to combine the overridden packages across the entire package set of Nixpkgs.

## &lt;pkg&gt;.override {#sec-pkg-override}

The function `override` is usually available for all the derivations in the nixpkgs expression (`pkgs`).

It is used to override the arguments passed to a function.

Example usages:

```nix
pkgs.foo.override { arg1 = val1; arg2 = val2; ... }
```

It's also possible to access the previous arguments.

```nix
pkgs.foo.override (previous: { arg1 = previous.arg1; ... })
```

<!-- TODO: move below programlisting to a new section about extending and overlays and reference it -->

```nix
import pkgs.path { overlays = [ (self: super: {
  foo = super.foo.override { barSupport = true ; };
  })]};
```

```nix
mypkg = pkgs.callPackage ./mypkg.nix {
  mydep = pkgs.mydep.override { ... };
  }
```

In the first example, `pkgs.foo` is the result of a function call with some default arguments, usually a derivation. Using `pkgs.foo.override` will call the same function with the given new arguments.

## &lt;pkg&gt;.overrideAttrs {#sec-pkg-overrideAttrs}

The function `overrideAttrs` allows overriding the attribute set passed to a `stdenv.mkDerivation` call, producing a new derivation based on the original one. This function is available on all derivations produced by the `stdenv.mkDerivation` function, which is most packages in the nixpkgs expression `pkgs`.

Example usages:

```nix
helloBar = pkgs.hello.overrideAttrs (finalAttrs: previousAttrs: {
  pname = previousAttrs.pname + "-bar";
});
```

In the above example, "-bar" is appended to the pname attribute, while all other attributes will be retained from the original `hello` package.

The argument `previousAttrs` is conventionally used to refer to the attr set originally passed to `stdenv.mkDerivation`.

The argument `finalAttrs` refers to the final attributes passed to `mkDerivation`, plus the `finalPackage` attribute which is equal to the result of `mkDerivation` or subsequent `overrideAttrs` calls.

If only a one-argument function is written, the argument has the meaning of `previousAttrs`.

Function arguments can be omitted entirely if there is no need to access `previousAttrs` or `finalAttrs`.

```nix
helloWithDebug = pkgs.hello.overrideAttrs {
  separateDebugInfo = true;
};
```

In the above example, the `separateDebugInfo` attribute is overridden to be true, thus building debug info for `helloWithDebug`.

::: {.note}
Note that `separateDebugInfo` is processed only by the `stdenv.mkDerivation` function, not the generated, raw Nix derivation. Thus, using `overrideDerivation` will not work in this case, as it overrides only the attributes of the final derivation. It is for this reason that `overrideAttrs` should be preferred in (almost) all cases to `overrideDerivation`, i.e. to allow using `stdenv.mkDerivation` to process input arguments, as well as the fact that it is easier to use (you can use the same attribute names you see in your Nix code, instead of the ones generated (e.g. `buildInputs` vs `nativeBuildInputs`), and it involves less typing).
:::

## &lt;pkg&gt;.overrideDerivation {#sec-pkg-overrideDerivation}

::: {.warning}
You should prefer `overrideAttrs` in almost all cases, see its documentation for the reasons why. `overrideDerivation` is not deprecated and will continue to work, but is less nice to use and does not have as many abilities as `overrideAttrs`.
:::

::: {.warning}
Do not use this function in Nixpkgs as it evaluates a derivation before modifying it, which breaks package abstraction. In addition, this evaluation-per-function application incurs a performance penalty, which can become a problem if many overrides are used. It is only intended for ad-hoc customisation, such as in `~/.config/nixpkgs/config.nix`.
:::

The function `overrideDerivation` creates a new derivation based on an existing one by overriding the original's attributes with the attribute set produced by the specified function. This function is available on all derivations defined using the `makeOverridable` function. Most standard derivation-producing functions, such as `stdenv.mkDerivation`, are defined using this function, which means most packages in the nixpkgs expression, `pkgs`, have this function.

Example usage:

```nix
mySed = pkgs.gnused.overrideDerivation (oldAttrs: {
  name = "sed-4.2.2-pre";
  src = fetchurl {
    url = "ftp://alpha.gnu.org/gnu/sed/sed-4.2.2-pre.tar.bz2";
    hash = "sha256-MxBJRcM2rYzQYwJ5XKxhXTQByvSg5jZc5cSHEZoB2IY=";
  };
  patches = [];
});
```

In the above example, the `name`, `src`, and `patches` of the derivation will be overridden, while all other attributes will be retained from the original derivation.

The argument `oldAttrs` is used to refer to the attribute set of the original derivation.

::: {.note}
A package's attributes are evaluated *before* being modified by the `overrideDerivation` function. For example, the `name` attribute reference in `url = "mirror://gnu/hello/${name}.tar.gz";` is filled-in *before* the `overrideDerivation` function modifies the attribute set. This means that overriding the `name` attribute, in this example, *will not* change the value of the `url` attribute. Instead, we need to override both the `name` *and* `url` attributes.
:::

## lib.makeOverridable {#sec-lib-makeOverridable}

The function `lib.makeOverridable` is used to make the result of a function easily customizable. This utility only makes sense for functions that accept an argument set and return an attribute set.

Example usage:

```nix
f = { a, b }: { result = a+b; };
c = lib.makeOverridable f { a = 1; b = 2; };
```

The variable `c` is the value of the `f` function applied with some default arguments. Hence the value of `c.result` is `3`, in this example.

The variable `c` however also has some additional functions, like
[c.override](#sec-pkg-override) which can be used to override the
default arguments. In this example the value of
`(c.override { a = 4; }).result` is 6.
