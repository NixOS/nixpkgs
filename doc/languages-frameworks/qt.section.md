# Qt {#sec-language-qt}

Writing Nix expressions for Qt libraries and applications is largely similar as for other C++ software.
This section assumes some knowledge of the latter.
There are two problems that the Nixpkgs Qt infrastructure addresses,
which are not shared by other C++ software:

1.  There are usually multiple supported versions of Qt in Nixpkgs.
    All of a package's dependencies must be built with the same version of Qt.
    This is similar to the version constraints imposed on interpreted languages like Python.
2.  Qt makes extensive use of runtime dependency detection.
    Runtime dependencies are made into build dependencies through wrappers.

## Nix expression for a Qt package (default.nix) {#qt-default-nix}

```{=docbook}
<programlisting>
{ stdenv, lib, qtbase, wrapQtAppsHook }: <co xml:id='qt-default-nix-co-1' />

stdenv.mkDerivation {
  pname = "myapp";
  version = "1.0";

  buildInputs = [ qtbase ];
  nativeBuildInputs = [ wrapQtAppsHook ]; <co xml:id='qt-default-nix-co-2' />
}
</programlisting>

 <calloutlist>
  <callout arearefs='qt-default-nix-co-1'>
   <para>
    Import Qt modules directly, that is: <literal>qtbase</literal>, <literal>qtdeclarative</literal>, etc.
    <emphasis>Do not</emphasis> import Qt package sets such as <literal>qt5</literal>
    because the Qt versions of dependencies may not be coherent, causing build and runtime failures.
   </para>
  </callout>
  <callout arearefs='qt-default-nix-co-2'>
    <para>
      All Qt packages must include <literal>wrapQtAppsHook</literal> in
      <literal>nativeBuildInputs</literal>, or you must explicitly set
      <literal>dontWrapQtApps</literal>.
    </para>
  </callout>
 </calloutlist>
```

## Locating runtime dependencies {#qt-runtime-dependencies}

Qt applications must be wrapped to find runtime dependencies.
Include `wrapQtAppsHook` in `nativeBuildInputs`:

```nix
{ stdenv, wrapQtAppsHook }:

stdenv.mkDerivation {
  # ...
  nativeBuildInputs = [ wrapQtAppsHook ];
}
```

Add entries to `qtWrapperArgs` are to modify the wrappers created by
`wrapQtAppsHook`:

```nix
{ stdenv, wrapQtAppsHook }:

stdenv.mkDerivation {
  # ...
  nativeBuildInputs = [ wrapQtAppsHook ];
  qtWrapperArgs = [ ''--prefix PATH : /path/to/bin'' ];
}
```

The entries are passed as arguments to [wrapProgram](#fun-wrapProgram).

Set `dontWrapQtApps` to stop applications from being wrapped automatically.
Wrap programs manually with `wrapQtApp`, using the syntax of
[wrapProgram](#fun-wrapProgram):

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

## Adding a library to Nixpkgs {#adding-a-library-to-nixpkgs}

Add Qt libraries to `qt5-packages.nix` to make them available for every
supported Qt version.

### Example adding a Qt library {#qt-library-all-packages-nix}

The following represents the contents of `qt5-packages.nix`.

```nix
{
  # ...

  mylib = callPackage ../path/to/mylib {};

  # ...
}
```

Libraries are built with every available version of Qt.
Use the `meta.broken` attribute to disable the package for unsupported Qt versions:

```nix
{ stdenv, lib, qtbase }:

stdenv.mkDerivation {
  # ...
  # Disable this library with Qt < 5.9.0
  meta.broken = lib.versionOlder qtbase.version "5.9.0";
}
```

## Adding an application to Nixpkgs {#adding-an-application-to-nixpkgs}

Add Qt applications to `qt5-packages.nix`. Add an alias to `all-packages.nix`
to select the Qt 5 version used for the application.

### Example adding a Qt application {#qt-application-all-packages-nix}

The following represents the contents of `qt5-packages.nix`.

```nix
{
  # ...

  myapp = callPackage ../path/to/myapp {};

  # ...
}
```

The following represents the contents of `all-packages.nix`.

```nix
{
  # ...

  myapp = libsForQt5.myapp;

  # ...
}
```
