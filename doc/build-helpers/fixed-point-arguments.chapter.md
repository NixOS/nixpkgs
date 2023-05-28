# Fixed-point arguments of build helpers {#chap-build-helpers-finalAttrs}

As mentioned in the beginning of this part, `stdenv.mkDerivation` could alternatively accept a fixed-point function. The input of such function, typically named `finalAttrs`, is expected to be the final state of the attribute set.
A build helper like this is said to accept **fixed-point arguments**.

Build helpers don't always support fixed-point arguments yet, as support in [`stdenv.mkDerivation`](#mkderivation-recursive-attributes) was first included in Nixpkgs 22.05.

## Defining a build helper with `lib.extendMkDerivation` {#sec-build-helper-extendMkDerivation}

The Nixpkgs library function [`lib.customisation.extendMkDerivation`](#function-library-lib.customisation.extendMkDerivation) can be used to define a build helper supporting fixed-point arguments from an existing one with such support, with an attribute overlay similar to the one taken by [`<pkg>.overrideAttrs`](#sec-pkg-overrideAttrs).

:::{.example #ex-build-helpers-mkLocalDerivation-extendMkDerivation}

# Example definition of `mkLocalDerivation` extended from `stdenv.mkDerivation` with `lib.extendMkDerivation`

Let's say we would like to define a build helper named `mkLocalDerivation` that builds locally without using substitutes by defaut.

Instead of taking a plain attribute set and do the composition like this,

```nix
{ preferLocalBuild ? true
, allowSubstitute ? false
, ...
}@args:

stdenv.mkDerivation ({
  inherit
    preferLocalBuild
    allowSubstitute
    ;
} // args)
```

we could define with `lib.extendMkDerivation` an an attribute overlay to make the result build helper also accepts the fixed point of the attribute set passing to the underlying `stdenv.mkDerivation`, named `finalAttrs` here:

```nix
lib.extendMkDerivation stdenv.mkDerivation (finalAttrs:

{ preferLocalBuild ? true
, allowSubstitute ? false
, ...
}@args:

# The attributes to update
{
  inherit
    preferLocalBuild
    allowSubstitute
    ;
})
# No need of `// args` here.
# The whole set of input arguments are passed in advance.
```
:::

Should there be a need to modify the result derivation, `lib.customisation.extendMkDerivationModified` additionally takes a derivation modification function as the first argument.

## Wrapping existing build helper definition with `lib.adaptMkDerivation` {#sec-build-helper-adaptMkDerivation}

Many existing build helpers have some arguments which cannot be passed down to the base build helper. This leads to the use of custom overriders (such as `overridePythonPackage`) and extra complexity when overriding.

As a wrapper around `<pkg>.overrideAttrs`, `lib.extendMkDerivation` passes the whole set of arguments directly to the base build helper before extending them, making it incompatible to build helpers with no-passing arguments.

To workaround this issue, [`lib.customisation.adaptMkDerivation`](#function-library-lib.customisation.adaptMkDerivation) is introduced. Instead of taking an attribute overlay that returns a subset of attributes to update, it takes an argument set adapter that returns the whole set of arguments to pass to the base build helper, allowing the removal of some arguments. This also minimize the expression change needed to adopt `lib.adaptMkDerivation` is also smaller, enabling a smooth transition toward fixed-point arguments support.

We could gradually move those no-passing arguments to `passthru`, deprecate custom overriders, and migrate to `lib.extendMkDerivation` later on.

The following is an example of conventional build helper definition with unable-to-pass arguments.

:::{.example #ex-build-helpers-mkLocalDerivation-adaptMkDerivation}

# Example definition of `mkLocalDerivation` extended from `stdenv.mkDerivation` with `lib.adaptMkDerivation`

Should the original definition of build helper `mkLocalDerivation` takes an argument `specialArg` that cannot be passed to the build helper,

```nix
{ preferLocalBuild ? true
, allowSubstitute ? false
, specialArg ? (_: false)
, ...
}@args:

stdenv.mkDerivation ({
  inherit
    preferLocalBuild
    allowSubstitute
    ;
  # Some expressions involving specialArg
  greeting = if specialArg "hi" then "hi" else "hello";
} // removeAttrs [
  "specialArg"
] args)
```
:::

wrap around the original definition with `lib.adaptMkDerivation` to make the result build helper also accept fixed-point arguments.

```nix
lib.adaptMkDerivation stdenv.mkDerivation (finalAttrs:

{ preferLocalBuild ? true
, allowSubstitute ? false
, specialArg ? (_: false)
, ...
}@args:

# The arguments to pass
{
  inherit
    preferLocalBuild
    allowSubstitute
    ;
  # Some expressions involving specialArg
  greeting =
    if specialArg "hi" then "hi" else "hello";
} // removeAttrs [
  "specialArg"
] args)
```

We could then refactor the definition to pass everything properly, while keeping some backward compatibility.

```nix
lib.adaptMkDerivation stdenv.mkDerivation (finalAttrs:

{ preferLocalBuild ? true
, allowSubstitute ? false
, specialArg ? (_: false)
, ...
}@args:

# The arguments to pass
{
  inherit
    preferLocalBuild
    allowSubstitute
    ;
  passthru = {
    specialArg =
      if (args?specialArg) then
        # For backward compatibility only.
        # TODO: Convert to throw after XX.XX branch-off.
        lib.warn
          "mkLocalDerivation: Expect specialArg under passthru."
          args.specialArg
      else
        (_: false);
  } // passthru;
  # Some expressions involving specialArg
  greeting =
    if finalAttrs.passthru.specialArg "hi" then "hi" else "hello";
} // removeAttrs [
  "specialArg"
] args)
```

Convert to `lib.extendMkDerivation` after deprecation of `specialArg`.

```nix
lib.extendMkDerivation stdenv.mkDerivation (finalAttrs:

{ preferLocalBuild ? true
, allowSubstitute ? false
, specialArg ? (_: false)
, ...
}@args:

# The arguments to pass
{
  inherit
    preferLocalBuild
    allowSubstitute
    ;
  passthru = {
    specialArg = lib.throwIf (args?specialArg)
      "mkLocalDerivation: Expect specialArg under passthru."
      (_: false);
  } // passthru;
  # Some expressions involving specialArg
  greeting =
    if finalAttrs.passthru.specialArg "hi" then "hi" else "hello";
})
```
:::
