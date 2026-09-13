# `guileImportsCheckHook` {#guileImportsCheckHook}

This hook checks if a guile package can be imported. The hook is automatically
propagated by `guile`, so using it is as simple as:

```nix
{
  lib,
  stdenv,
  guile,
  # ...
}:

stdenv.mkDerivation (finalAttrs: {
  # ...

  nativeBuildInputs = [ guile ];

  guileImportsCheck = [
    "package"
  ];

  # ...
})
```

The `guileImportsCheckHook` package can also included manually in
`nativeBuildInputs` if one desires.
