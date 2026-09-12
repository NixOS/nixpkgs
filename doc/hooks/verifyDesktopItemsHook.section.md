# verifyDesktopItemsHook {#verifydesktopitemshook}

The `verifyDesktopItemsHook` derivation adds `verifyDesktopItemsPhase` to the [`preInstallCheckHooks`](#ssec-installCheck-phase),
which finds all desktop files in the bin output and verifies both their general syntax, and that the references resources exist.
It can be used in any package that installs desktop items, to ensure that the desktop entry will work correctly when installed on a user's system.

The hook runs in `installCheckPhase`, requiring `doInstallCheck` is enabled for the hook to take effect:

```nix
{
  lib,
  stdenv,
  copyDesktopItems,
  verifyDesktopItemsHook,
  # ...
}:

stdenv.mkDerivation (finalAttrs: {
  # ...

  doInstallCheck = true;
  nativeInstallCheckInputs = [ verifyDesktopItemsHook ];

  # ...
})
```

Note that for [`buildPythonPackage`](#buildpythonpackage-function) and [`buildPythonApplication`](#buildpythonapplication-function), `doInstallCheck` is enabled by default.

Only the bin output's `share/applications` directory is scanned for desktop files.
If no desktop files are found, the hook is basically a no-op.

For each desktop file found:

- `desktop-file-validate` is run on it.
- The `Exec` and `TryExec` commands are checked to exist, either as an absolute path, or in `bin` or `sbin` of the bin output.
- The `Icon` is checked to exist. It should be either of the following:
  - An absolute path to an icon file.
  - The name of one of the standard icons in the [Icon Naming Specification](https://specifications.freedesktop.org/icon-naming/latest#names).
  - The name of an icon in `share/pixmaps` or `share/icons` of any output.
    The corresponding file must use one of the extensions allowed by the [Icon Theme Specification](https://specifications.freedesktop.org/icon-theme/latest/#directory_layout): `.png`, `.svg`, `.xpm`.

The variables that this phase controls are:

- `dontVerifyDesktopItems`: Disable adding this hook to the [`preInstallCheckHooks`](#ssec-installCheck-phase).
- `verifyDesktopItemsSkip`: A list of desktop file names (e.g. `myapp.desktop`) to skip verification for.
