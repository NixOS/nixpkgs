# Qt {#sec-language-qt}

This section describes the differences between Nix expressions for Qt libraries and applications and Nix expressions for other C++ software. Some knowledge of the latter is assumed.

There are primarily two problems which the Qt infrastructure is designed to address: ensuring consistent versioning of all dependencies and finding dependencies at runtime.

## Nix expression for a Qt package (default.nix) {#qt-default-nix}

```{=docbook}
<programlisting>
{ mkDerivation, qtbase }: <co xml:id='qt-default-nix-co-1' />

mkDerivation { <co xml:id='qt-default-nix-co-2' />
  pname = "myapp";
  version = "1.0";

  buildInputs = [ qtbase ]; <co xml:id='qt-default-nix-co-3' />
}
</programlisting>

 <calloutlist>
  <callout arearefs='qt-default-nix-co-1'>
   <para>
    Import <literal>mkDerivation</literal> and Qt (such as <literal>qtbase</literal> modules directly. <emphasis>Do not</emphasis> import Qt package sets; the Qt versions of dependencies may not be coherent, causing build and runtime failures.
   </para>
  </callout>
  <callout arearefs='qt-default-nix-co-2'>
   <para>
    Use <literal>mkDerivation</literal> instead of <literal>stdenv.mkDerivation</literal>. <literal>mkDerivation</literal> is a wrapper around <literal>stdenv.mkDerivation</literal> which applies some Qt-specific settings. This deriver accepts the same arguments as <literal>stdenv.mkDerivation</literal>; refer to <xref linkend='chap-stdenv' /> for details.
   </para>
   <para>
    To use another deriver instead of <literal>stdenv.mkDerivation</literal>, use <literal>mkDerivationWith</literal>:
<programlisting>
mkDerivationWith myDeriver {
  # ...
}
</programlisting>
    If you cannot use <literal>mkDerivationWith</literal>, please refer to <xref linkend='qt-runtime-dependencies' />.
   </para>
  </callout>
  <callout arearefs='qt-default-nix-co-3'>
   <para>
    <literal>mkDerivation</literal> accepts the same arguments as <literal>stdenv.mkDerivation</literal>, such as <literal>buildInputs</literal>.
   </para>
  </callout>
 </calloutlist>
```

## Locating runtime dependencies {#qt-runtime-dependencies}
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
## Adding a library to Nixpkgs
Qt libraries are added to `qt5-packages.nix` and are made available for every Qt
version supported.
### Example adding a Qt library {#qt-library-all-packages-nix}

The following represents the contents of `qt5-packages.nix`.
```
{
  # ...

  mylib = callPackage ../path/to/mylib {};

  # ...
}
```
## Adding an application to Nixpkgs
Applications that use Qt are also added to `qt5-packages.nix`. An alias is added
in the top-level `all-packages.nix` pointing to the package with the desired Qt5 version.

### Example adding a Qt application {#qt-application-all-packages-nix}

The following represents the contents of `qt5-packages.nix`.
```
{
  # ...

  myapp = callPackage ../path/to/myapp {};

  # ...
}
```

The following represents the contents of `all-packages.nix`.
```
{
  # ...

  myapp = libsForQt5.myapp;

  # ...
}
```
