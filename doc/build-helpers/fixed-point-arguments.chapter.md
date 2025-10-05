# Fixed-point arguments of build helpers {#chap-build-helpers-finalAttrs}

As mentioned in the beginning of this part, `stdenv.mkDerivation` could alternatively accept a fixed-point function. The input of this function, typically named `finalAttrs`, is expected to be the final state of the attribute set.  A build helper like this is said to accept **fixed-point arguments**.

Build helpers don't always support fixed-point arguments yet, as support in [`stdenv.mkDerivation`](#mkderivation-recursive-attributes) was first included in Nixpkgs 22.05.

## Defining a build helper with `lib.extendMkDerivation` {#sec-build-helper-extendMkDerivation}

Developers can use the Nixpkgs library function [`lib.customisation.extendMkDerivation`](#function-library-lib.customisation.extendMkDerivation) to define a build helper supporting fixed-point arguments from an existing one with such support, with an attribute overlay similar to the one taken by [`<pkg>.overrideAttrs`](#sec-pkg-overrideAttrs).

Besides overriding, `lib.extendMkDerivation` also supports `excludeDrvArgNames` to optionally exclude some arguments in the input fixed-point arguments from passing down the base build helper (specified as `constructDrv`).

:::{.example #ex-build-helpers-extendMkDerivation}

# Example definition of `mkLocalDerivation` extended from `stdenv.mkDerivation` with `lib.extendMkDerivation`

We want to define a build helper named `mkLocalDerivation` that builds locally without using substitutes by default.

Instead of taking a plain attribute set,

```nix
{
  preferLocalBuild ? true,
  allowSubstitute ? false,
  specialArg ? (_: false),
  ...
}@args:

stdenv.mkDerivation (
  removeAttrs [
    # Don't pass specialArg into mkDerivation.
    "specialArg"
  ] args
  // {
    # Arguments to pass
    inherit preferLocalBuild allowSubstitute;
    # Some expressions involving specialArg
    greeting = if specialArg "hi" then "hi" else "hello";
  }
)
```

we could define with `lib.extendMkDerivation` an attribute overlay to make the result build helper also accept the attribute set's fixed point passing to the underlying `stdenv.mkDerivation`, named `finalAttrs` here:

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

If one needs to apply extra changes to the result derivation, pass the derivation transformation function to `lib.extendMkDerivation` as `lib.customisation.extendMkDerivation { transformDrv = drv: ...; }`.
