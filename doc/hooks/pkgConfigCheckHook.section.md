# `pkgConfigCheckHook` {#pkgConfigCheckHook}

This hook adds check to [`preInstallCheckHooks`](#ssec-installCheck-phase) that validates a package's `pkg-config` module(s).

If this check fails, then the whole build will fail. A softer option is `testers.hasPkgConfigModules`.

Use it like this:

```nix
{
  doInstallCheck = true;
  nativeInstallCheckInputs = [ pkgConfigCheckHook ];
  pkgConfigModules = [
    "xyzlib"
    "abc"
  ];
}
```

The variables that this phase control are:

- `dontPkgConfigCheck`: Disable adding this hook to the [`preInstallCheckHooks`](#ssec-installCheck-phase).
- `dontPkgConfigCheckVersion`: Disable comparing the package's `.pc` version to its `$version` environment variable (passed by the derivation). Useful when upstream forgets to bump their `.pc` or uses a different version format.

This check searches all outputs `lib/pkgconfig` and `share/pkgconfig` directories for `.pc` files.
