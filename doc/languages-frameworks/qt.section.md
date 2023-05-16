# Qt {#sec-language-qt}

Writing Nix expressions for Qt libraries and applications is largely similar as for other C++ software.
This section assumes some knowledge of the latter.

The major caveat with Qt applications is that Qt uses a plugin system to load additional modules at runtime,
from a list of well-known locations. In Nixpkgs, we patch QtCore to instead use an environment variable,
and wrap Qt applications to set it to the right paths. This effectively makes the runtime dependencies
pure and explicit at build-time, at the cost of introducing an extra indirection.

## Nix expression for a Qt package (default.nix) {#qt-default-nix}

<<<<<<< HEAD
```nix
{ stdenv, lib, qtbase, wrapQtAppsHook }:
=======
```{=docbook}
<programlisting>
{ stdenv, lib, qtbase, wrapQtAppsHook }: <co xml:id='qt-default-nix-co-1' />
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation {
  pname = "myapp";
  version = "1.0";

  buildInputs = [ qtbase ];
<<<<<<< HEAD
  nativeBuildInputs = [ wrapQtAppsHook ];
}
```

It is important to import Qt modules directly, that is: `qtbase`, `qtdeclarative`, etc. *Do not* import Qt package sets such as `qt5` because the Qt versions of dependencies may not be coherent, causing build and runtime failures.

Additionally all Qt packages must include `wrapQtAppsHook` in `nativeBuildInputs`, or you must explicitly set `dontWrapQtApps`.

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
