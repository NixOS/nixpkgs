# Fixed-point arguments of build helpers {#chap-build-helpers-finalAttrs}

`stdenv.mkDerivation` also accepts a [fixed-point function](#function-library-lib.fixedPoints.fix) instead of a plain attribute set:

```nix
{
  stdenv,
  fetchurl,
}:
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

Attributes that reference each other through `finalAttrs` stay correct when changing any of them with [`overrideAttrs`](#sec-pkg-overrideAttrs), because they all access the final values of the fixed-point computation.

`rec` cannot do this: its self-references are fixed when the set is defined and ignore later overrides.
See [recursive-sets](https://nix.dev/manual/nix/stable/language/syntax#recursive-sets) for the underlying mechanism.

## Define a build helper with `lib.extendMkDerivation` {#sec-build-helper-extendMkDerivation}

Use [`lib.customisation.extendMkDerivation`](#function-library-lib.customisation.extendMkDerivation) to define a build helper with fixed-point support from an existing one.
Its argument `extendDrvArgs` takes an attribute overlay similar to [`<pkg>.overrideAttrs`](#sec-pkg-overrideAttrs).

Besides overriding, `lib.extendMkDerivation` also supports `excludeDrvArgNames` to optionally exclude some arguments in the input fixed-point arguments from passing down to the base build helper (specified as `constructDrv`).

:::{.example #ex-build-helpers-extendMkDerivation}

# Example `mkLocalDerivation` - a build helper over `mkDerivation`

Define a build helper named `mkLocalDerivation` that builds locally without using substitutes by default.

Use `lib.extendMkDerivation`:

```nix
{
  lib,
  stdenv,
}:
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

To apply extra changes to the result derivation, pass `transformDrv` to `lib.extendMkDerivation`:

```nix
lib.customisation.extendMkDerivation { transformDrv = drv: /...; }
```

Construct a wrapper derivation around another derivation using `transformDrv`

The wrapper has access to the original arguments

:::{.example #ex-build-helpers-extendMkDerivation-transformDrv-wrapper}

# Define a custom build helper that downloads and builds

```nix
{
  lib,
  stdenvNoCC,
  cacert,
  configure-example,
  download-example,
}:

lib.extendMkDerivation {
  constructDrv = stdenvNoCC.mkDerivation;

  excludeDrvArgNames = [
    "bar"
  ];

  extendDrvArgs =
    finalAttrs:
    {
      bar,
      foo,
      hash ? "",
      ...
    }@args:
    {
      inherit hash;
      nativeBuildInputs = args.nativeBuildInputs or [ ] ++ [
        cacert
        download-example
      ];
      buildPhase = ''
        runHook preBuild
        download-example --foo="$foo" --out="$out"
        runHook postBuild
      '';
      impureEnvVars = lib.fetchers.proxyImpureEnvVars;
      outputHash = if finalAttrs.hash != "" then finalAttrs.hash else lib.fakeHash;
      outputHashFormat = "recursive";
      passthru = args.passthru or { } // {
        inherit bar;
      };
    };

  transformDrv =
    unwrapped:
    stdenvNoCC.mkDerivation (finalAttrs: {
      name = finalAttrs.src.name + "-wrapped";
      src = unwrapped;
      nativeBuildInputs = [
        configure-example
      ];
      inherit (unwrapped) bar;
      buildPhase = ''
        runHook preBuild
        configure-example --bar="$bar"
        runHook postBuild
      '';
    });
}
```
