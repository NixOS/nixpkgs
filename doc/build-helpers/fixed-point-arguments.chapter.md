# Fixed-point arguments of build helpers {#chap-build-helpers-finalAttrs}

`stdenv.mkDerivation` accepts a fixed-point function instead of a plain attribute set:

```nix
stdenv.mkDerivation (finalAttrs: {
  pname = "hello";
  version = "2.12";

  src = fetchurl {
    url = "mirror://gnu/hello/hello-${finalAttrs.version}.tar.gz";
    hash = "sha256-...";
  };
})
```

The function's input, conventionally named `finalAttrs`, is the final state of the attribute set. Here `src` reads `finalAttrs.version` instead of repeating the version string. A build helper like this is said to accept **fixed-point arguments**.

This is what makes a package easy to override: attributes that reference each other through `finalAttrs` stay correct when someone changes one of them, because they all resolve to the final values. For an example of what an override looks like, see [`<pkg>.overrideAttrs`](#sec-pkg-overrideAttrs).

`rec` cannot do this: its self-references are fixed when the set is defined and ignore later overrides.
See [recursive attributes in `mkDerivation`](#mkderivation-recursive-attributes) for the underlying mechanism.

Support for fixed-point arguments was added to [`stdenv.mkDerivation`](#mkderivation-recursive-attributes) in Nixpkgs 22.05.

## Define a build helper with `lib.extendMkDerivation` {#sec-build-helper-extendMkDerivation}

Use [`lib.customisation.extendMkDerivation`](#function-library-lib.customisation.extendMkDerivation) to define a build helper with fixed-point support from an existing one. It takes an attribute overlay similar to [`<pkg>.overrideAttrs`](#sec-pkg-overrideAttrs).

Besides overriding, `lib.extendMkDerivation` also supports `excludeDrvArgNames` to optionally exclude some arguments in the input fixed-point arguments from passing down to the base build helper (specified as `constructDrv`).

:::{.example #ex-build-helpers-extendMkDerivation}

# Example `mkLocalDerivation` - a build helper over `mkDerivation`

Define a build helper named `mkLocalDerivation` that builds locally without using substitutes by default.

Use `lib.extendMkDerivation`:

```nix
lib.extendMkDerivation {
  constructDrv = stdenv.mkDerivation;
  excludeDrvArgNames = [
    # Don't pass specialArg into mkDerivation.
    "specialArg"
  ];
  extendDrvArgs =
    finalAttrs:
    {
      preferLocalBuild ? true,
      allowSubstitute ? false,
      specialArg ? (_: false),
      ...
    }@args:
    {
      # Arguments to pass
      inherit preferLocalBuild allowSubstitute;
      # Some expressions involving specialArg
      greeting = if specialArg "hi" then "hi" else "hello";
    };
}
```
:::

If you need to apply extra changes to the result derivation, pass the derivation transformation function to `lib.extendMkDerivation`:

```nix
lib.customisation.extendMkDerivation { transformDrv = drv: /...; }
```
