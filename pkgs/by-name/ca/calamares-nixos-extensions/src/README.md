# Calamares Branding and Module Examples

> A *branding component* in Calamares is a description of the
> produce (i.e. distribution) being installed along with a "slideshow" 
> that is displayed during the installation phase of Calamares.
>
> A *module* adds functionality to Calamares; modules may be written
> in C++ or Python, using Qt Widgets or QML for the UI (with C++)
> if there is one. Both C++ and Python allow a full control over the
> target system during the installation.

This repository contains complete examples of branding and some
modules for Calamares.

- [Branding](#branding) documentation
  - [default](branding/default/branding.desc) branding example
  - [fancy](branding/fancy/branding.desc) branding example
  - [KaOS](branding/kaos_branding/branding.desc) branding example
  - [SameGame](branding/samegame/branding.desc) branding example
- [Module](#module) documentation
  
## Branding 

> Branding shapes the **look** of Calamares to your distro

Calamares ships with (just) one default branding component which
can be used for testing. The examples here show what can be done
with QML in the context of Calamares branding, and provide examples
and documentation for the framework that Calamares ships with.

 - `default/` is a copy of the default branding included with Calamares.
 - `fancy/` has navigation buttons and a slide counter.
 - `kaos_branding/` is a copy of the KaOS branding component, which
   has translations and a bunch of fancy graphics.
 - `samegame/` is a copy of the Qt Company "Same Game" QML demo. It
   shows that **any** QML can be used for branding purposes.

### Writing your own Branding

- TODO: some notes on `branding.desc` and links
- TODO: some notes on QML and links
- TODO: styling notes
- TODO: alternative panels
   
### Testing a Branding Component

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

> **Note** that running a QML slideshow inside Calamares is slightly
> different. Calamares internally can call functions in the slideshow,
> and can set a property in the slideshow, to indicate that the show
> is now visible and should start.

### Calamares Branding API

- TODO: calling `onActivate()` and `onLeave()`
- TODO: property `activatedInCalamares`


## Modules

> Modules extend the **functionality** of Calamares for your distro

### C++ Modules

### Python Modules

