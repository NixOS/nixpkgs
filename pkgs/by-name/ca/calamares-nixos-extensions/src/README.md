# Calamares Branding Examples

> A *branding component* in Calamares is a QML "slideshow" that is
> displayed during the installation phase of Calamares -- while it is
> doing things to the target system. The component also provides
> the names and descriptions of the product (i.e. distribution)
> being installed.

This repository contains complete examples of branding for Calamares.
Calamares ships with (just) one default branding component which
can be used for testing. The examples here show what can be done
with QML in the context of Calamares branding, and provide examples
and documentation for the framework that Calamares ships with.

 - `default/` is a copy of the default branding that is included with Calamares
 - `fancy/` has navigation buttons and a slide counter
 - `samegame/` is a copy of the Qt Company "Same Game" QML demo. It
   shows that **any** QML can be used for branding purposes.

## Testing a Branding Component

If Calamares is installed, then the Calamares QML support files
are also installed; usually under `/usr/local/share/calamares/qml/`.
Some branding components need those support files, although a
branding component is free to do whatever is interesting in QML.

The tool for quickly viewing QML files is `qmlscene`, which is
included with the Qt development tools. It can be used to
preview a Calamares branding component (slideshow) without starting 
Calamares.  If the component uses translations, you will need to
build the translations first (using Qt Linguist `lrelease`, or by
using the normal build system for branding components).

Suppose we want to test the Calamares branding component *fancy*,
which has a root QML file `fancy/show.qml`. Translations have been
built and are in `build/calamares-fancy_nl.qm`. Calamares is installed
in the usual location. Then we can run

```
qmlscene \
    -translation build/calamares-fancy_nl.qm \
    -I /usr/local/share/calamares/qml \
    -geometry 600x400 \
    fancy/show.qml 
```

This starts the viewer with the Dutch (nl) translation, using the
support files already installed, in a 600x400 pixel window. By doing
so, the slideshow can be developed much more quickly (and with more
fancy effects) than by going through the Calamares install process
every time.


