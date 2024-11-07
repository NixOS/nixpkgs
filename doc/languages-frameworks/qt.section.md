# Qt {#sec-language-qt}

Writing Nix expressions for Qt libraries and applications is largely similar as for other C++ software.
This section assumes some knowledge of the latter.

The major caveat with Qt applications is that Qt uses a plugin system to load additional modules at runtime.
In Nixpkgs, we wrap Qt applications to inject environment variables telling Qt where to discover the required plugins and QML modules.

This effectively makes the runtime dependencies pure and explicit at build-time, at the cost of introducing
an extra indirection.

## Nix expression for a Qt package (default.nix) {#qt-default-nix}

```nix
{ stdenv, qt6 }:

stdenv.mkDerivation {
  pname = "myapp";
  version = "1.0";

  buildInputs = [ qt6.qtbase ];
  nativeBuildInputs = [ qt6.wrapQtAppsHook ];
}
```

The same goes for Qt 5 where libraries and tools are under `libsForQt5`.

Any Qt package should include `wrapQtAppsHook` or `wrapQtAppsNoGuiHook` in `nativeBuildInputs`, or explicitly set `dontWrapQtApps` to bypass generating the wrappers.

::: {.note}

`wrapQtAppsHook` propagates plugins and QML components from `qtwayland` on platforms that support it, to allow applications to act as native Wayland clients. It should be used for all graphical applications.

`wrapQtAppsNoGuiHook` does not propagate `qtwayland` to reduce closure size for purely command-line applications.

:::

## Packages supporting multiple Qt versions {#qt-versions}

If your package is a library that can be built with multiple Qt versions, you may want to take Qt modules as separate arguments (`qtbase`, `qtdeclarative` etc.), and invoke the package from `pkgs/top-level/qt5-packages.nix` or `pkgs/top-level/qt6-packages.nix` using the respective `callPackage` functions.

Applications should generally be built with upstream's preferred Qt version.

## Locating additional runtime dependencies {#qt-runtime-dependencies}

Add entries to `qtWrapperArgs` are to modify the wrappers created by
`wrapQtAppsHook`:

```nix
{ stdenv, qt6 }:

stdenv.mkDerivation {
  # ...
  nativeBuildInputs = [ qt6.wrapQtAppsHook ];
  qtWrapperArgs = [ ''--prefix PATH : /path/to/bin'' ];
}
```

The entries are passed as arguments to [wrapProgram](#fun-wrapProgram).

If you need more control over the wrapping process, set `dontWrapQtApps` to disable automatic wrapper generation,
and then create wrappers manually in `fixupPhase`, using `wrapQtApp`, which itself is a small wrapper over [wrapProgram](#fun-wrapProgram):

The `makeWrapper` arguments required for Qt are also exposed in the environment as `$qtWrapperArgs`.

```nix
{ stdenv, lib, wrapQtAppsHook }:

stdenv.mkDerivation {
  # ...
  nativeBuildInputs = [ wrapQtAppsHook ];
  dontWrapQtApps = true;
  preFixup = ''
      wrapQtApp "$out/bin/myapp" --prefix PATH : /path/to/bin
  '';
}
```

::: {.note}
`wrapQtAppsHook` ignores files that are non-ELF executables.
This means that scripts won't be automatically wrapped so you'll need to manually wrap them as previously mentioned.
An example of when you'd always need to do this is with Python applications that use PyQt.
:::
