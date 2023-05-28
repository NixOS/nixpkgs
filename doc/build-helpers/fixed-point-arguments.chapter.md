# Fixed-point arguments of build helpers {#chap-build-helpers-finalAttrs}

As mentioned in the beginning of this part, `stdenv.mkDerivation` could alternatively accept a fixed-point function. The input of such function, typically named `finalAttrs`, is expected to be the final state of the attribute set.
A build helper like this is said to accept **fixed-point arguments**.

Build helpers don't always support fixed-point arguments yet, as support in [`stdenv.mkDerivation`](#mkderivation-recursive-attributes) was first included in Nixpkgs 22.05.

## Defining a build helper with `lib.extendMkDerivation` {#sec-build-helper-extendMkDerivation}

Developers can use the Nixpkgs library function [`lib.customisation.extendMkDerivation`](#function-library-lib.customisation.extendMkDerivation) to define a build helper supporting fixed-point arguments from an existing one with such support, with an attribute overlay similar to the one taken by [`<pkg>.overrideAttrs`](#sec-pkg-overrideAttrs).

:::{.example #ex-build-helpers-mkLocalDerivation-extendMkDerivation}

# Example definition of `mkLocalDerivation` extended from `stdenv.mkDerivation` with `lib.extendMkDerivation`

We want to define a build helper named `mkLocalDerivation` that builds locally without using substitutes by default.

Instead of taking a plain attribute set,

```nix
{
  preferLocalBuild ? true,
  allowSubstitute ? false,
  ...
}@args:

stdenv.mkDerivation (
  args
  // {
    # Attributes to update
    inherit preferLocalBuild allowSubstitute;
  }
)
```

we could define with `lib.extendMkDerivation` an attribute overlay to make the result build helper also accepts the the attribute set's fixed point passing to the underlying `stdenv.mkDerivation`, named `finalAttrs` here:

```nix
lib.extendMkDerivation { } stdenv.mkDerivation (
  finalAttrs:
  {
    preferLocalBuild ? true,
    allowSubstitute ? false,
    ...
  }@args:

  # No need of `args //` here.
  # The whole set of input arguments is passed in advance.
  {
    # Attributes to update
    inherit preferLocalBuild allowSubstitute;
  }
)
```
:::

Should there be a need to modify the result derivation, pass the derivation modifying function to `lib.extendMkDerivation` as `lib.customisation.extendMkDerivation { modify = drv: ...; }`.

## Wrapping existing build helper definition with `lib.adaptMkDerivation` {#sec-build-helper-adaptMkDerivation}

Many existing build helpers only pass part of their arguments down to their base build helper, leading to the use of custom overriders (such as `overridePythonPackage`) and extra complexity when overriding.

As a wrapper around [`overrideAttrs`](#sec-pkg-overrideAttrs), `lib.extendMkDerivation` passes the whole set of arguments directly to the base build helper before extending them, making it incompatible with build helpers that only pass part of their input arguments down the base build helper.

To workaround this issue, [`lib.customisation.adaptMkDerivation`](#function-library-lib.customisation.adaptMkDerivation) is introduced. Instead of taking an attribute overlay that returns a subset of attributes to update, it takes an argument set adapter that returns the whole set of arguments to pass to the base build helper, allowing the removal of some arguments. The expression change needed to adopt `lib.adaptMkDerivation` is also smaller, enabling a smooth transition toward fixed-point arguments.

:::{.example #ex-build-helpers-mkLocalDerivation-adaptMkDerivation}

# Example definition of `mkLocalDerivation` extended from `stdenv.mkDerivation` with `lib.adaptMkDerivation`

Should the original definition of build helper `mkLocalDerivation` take an argument `specialArg` that cannot be passed to `sdenv.mkDerivation`,

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

wrap around the original definition with `lib.adaptMkDerivation` to make the result build helper accept fixed-point arguments.

```nix
lib.adaptMkDerivation { } stdenv.mkDerivation (
  finalAttrs:
  {
    preferLocalBuild ? true,
    allowSubstitute ? false,
    specialArg ? (_: false),
    ...
  }@args:

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
:::

In the long run, we would like to refactor build helpers to pass every argument down to `stdenv.mkDerivation`, so that they can all be overridden by [`overrideAttrs`](#sec-pkg-overrideAttrs), eliminating the use of custom overriders (e.g., `overridePythonAttrs`).

The following example shows a smooth migration from `lib.adaptMkDerivation` to `lib.extendMkDerivation`:

:::{.example #ex-build-helpers-mkLocalDerivation-migration}

# Migrating `mkLocalDerivation` from `lib.adaptMkDerivation` to `lib.extendMkDerivation`

Refactor the definition to pass `specialArg` properly while keeping some backward compatibility.

```nix
lib.adaptMkDerivation { } stdenv.mkDerivation (
  finalAttrs:
  {
    preferLocalBuild ? true,
    allowSubstitute ? false,
    specialArg ? (_: false),
    ...
  }@args:

  # The arguments to pass
  {
    inherit preferLocalBuild allowSubstitute;
    passthru = {
      specialArg =
        if (args ? specialArg) then
          # For backward compatibility only.
          # TODO: Convert to throw after XX.XX branch-off.
          lib.warn "mkLocalDerivation: Expect specialArg under passthru." args.specialArg
        else
          (_: false);
    } // args.passthru or { };
    # Some expressions involving specialArg
    greeting = if finalAttrs.passthru.specialArg "hi" then "hi" else "hello";
  }
  // removeAttrs [ "specialArg" ] args
)
```

Convert to `lib.extendMkDerivation` after deprecating `specialArg`.

```nix
lib.extendMkDerivation { } stdenv.mkDerivation (
  finalAttrs:

  {
    preferLocalBuild ? true,
    allowSubstitute ? false,
    ...
  }@args:

  # The arguments to pass
  {
    inherit preferLocalBuild allowSubstitute;
    passthru = {
      specialArg =
        (lib.throwIf (args ? specialArg) "mkLocalDerivation: Expect specialArg under passthru.")
          (_: false);
    } // args.passthru or { };
    # Some expressions involving specialArg
    greeting = if finalAttrs.passthru.specialArg "hi" then "hi" else "hello";
  }
)
```
:::
