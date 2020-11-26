
Qt
=
This section describes the differences between Nix expressions for Qt libraries and applications and Nix expressions for other C++ software. Some knowledge of the latter is assumed.

There are primarily two problems which the Qt infrastructure is designed to address: ensuring consistent versioning of all dependencies and finding dependencies at runtime.

**Nix expression for a Qt package (default.nix)**

```nix
{ mkDerivation, lib, qtbase }: #1
mkDerivation { #2
  pname = "myapp";
  version = "1.0";

  buildInputs = [ qtbase ]; #3
}
```

* **#1:** Import `mkDerivation` and Qt (such as `qtbase` modules directly. *Do not* import Qt package sets; the Qt versions of dependencies may not be coherent, causing build and runtime failures.

* **#2:** Use `mkDerivation` instead of `stdenv.mkDerivation`. `mkDerivation` is a wrapper around `stdenv.mkDerivation` which applies some Qt-specific settings. This deriver accepts the same arguments as `stdenv.mkDerivation`; refer to [Chapter 6, The Standard Environment](#chap-stdenv), The Standard Environment for details.

> To use another deriver instead of `stdenv.mkDerivation`, use `mkDerivationWith`:

```nix
mkDerivationWith myDeriver {
  # ...
}
```

> If you cannot use `mkDerivationWith`, please refer to Locating runtime dependencies below.

* **#3:** `mkDerivation` accepts the same arguments as `stdenv.mkDerivation`, such as `buildInputs`.

---

**Locating runtime dependencies**
Qt applications need to be wrapped to find runtime dependencies. If you cannot use `mkDerivation` or `mkDerivationWith` above, include `wrapQtAppsHook` in `nativeBuildInputs`:

```nix
stdenv.mkDerivation {
  # ...

  nativeBuildInputs = [ wrapQtAppsHook ];
}
```
Entries added to `qtWrapperArgs` are used to modify the wrappers created by `wrapQtAppsHook`. The entries are passed as arguments to [wrapProgram executable makeWrapperArgs](#fun-wrapProgram).

```nix
mkDerivation {
  # ...

  qtWrapperArgs = [ ''--prefix PATH : /path/to/bin'' ];
}
```

Set `dontWrapQtApps` to stop applications from being wrapped automatically. It is required to wrap applications manually with `wrapQtApp`, using the syntax of [wrapProgram executable makeWrapperArgs](#fun-wrapProgram):

```nix
mkDerivation {
  # ...

  dontWrapQtApps = true;
  preFixup = ''
      wrapQtApp "$out/bin/myapp" --prefix PATH : /path/to/bin
  '';
}
```

> Note: `wrapQtAppsHook` ignores files that are non-ELF executables. This means that scripts won't be automatically wrapped so you'll need to manually wrap them as previously mentioned. An example of when you'd always need to do this is with Python applications that use PyQT.

Libraries are built with every available version of Qt. Use the `meta.broken` attribute to disable the package for unsupported Qt versions:

```nix
mkDerivation {
  # ...

  # Disable this library with Qt &lt; 5.9.0
  meta.broken = builtins.compareVersions qtbase.version "5.9.0" &lt; 0;
}
```
**Adding a library to Nixpkgs**
   Add a Qt library to all-packages.nix by adding it to the collection inside `mkLibsForQt5`. This ensures that the library is built with every available version of Qt as needed.

**Example 15.9. Adding a Qt library to all-packages.nix**

```
{
  # ...

  mkLibsForQt5 = self: with self; {
    # ...

    mylib = callPackage ../path/to/mylib {};
  };

  # ...
}
```
**Adding an application to Nixpkgs**
Add a Qt application to *all-packages.nix* using `libsForQt5.callPackage` instead of the usual `callPackage`. The former ensures that all dependencies are built with the same version of Qt.

**Example 15.10 Adding a QT application to all-packages.nix**
```nix
{
  # ...

  myapp = libsForQt5.callPackage ../path/to/myapp/ {};

  # ...
}
```
