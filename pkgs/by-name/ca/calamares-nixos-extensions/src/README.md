# Calamares Branding and Module Examples

> A *branding component* in Calamares is a description of the
> product (i.e. distribution) being installed along with a "slideshow"
> that is displayed during the installation phase of Calamares.
> This shapes the **look** of your installation.
>
> A *module* adds **functionality** to Calamares; modules may be written
> in C++ or Python, using Qt Widgets or QML for the UI (with C++)
> if there is one. Both C++ and Python allow a full control over the
> target system during the installation.

This repository contains complete examples of branding and some
modules for Calamares.

- [Branding](#branding) documentation
- [Module](#modules) documentation

## Branding

> Branding shapes the **look** of Calamares to your distro

Calamares ships with (just) one default branding component which
can be used for testing. The examples here show what can be done
with QML in the context of Calamares branding, and provide examples
and documentation for the framework that Calamares ships with.

 - [`default/`](branding/default/branding.desc)
   is a copy of the default branding included with Calamares.
 - [`fancy/`](branding/fancy/branding.desc)
   has navigation buttons and a slide counter.
 - [`image-slideshow/`](branding/image-slideshow/branding.desc)
   is a variant of the *default* branding that implements its
   own slide element for QML that supports a single image.
   This is useful for straightforward images-only slideshows
   (probably moreso than the default slideshow).
 - [`kaos_branding/`](branding/kaos_branding/branding.desc)
   is a copy of the KaOS branding component, which
   has translations and a bunch of fancy graphics.
 - [`samegame/` ](branding/default/branding.desc)
   is a copy of the Qt Company "Same Game" QML demo. It
   shows that **any** QML can be used for branding purposes.

### Writing your own Branding

- *Branding descriptor* The basis of branding is the `branding.desc`
  file, which describes the overall branding. The default `branding.desc`
  in the Calamares source repository has extensive documentation. You can:
  - configure strings displayed in Calamares that name your distro
  - configure images and colors used
  - control the size and placement of the Calamares window on startup
  - choose navigation and control panel styles
  - select or construct a slideshow to display during long-running
    installation steps.

  See the [deployment guide](https://github.com/calamares/calamares/wiki/Deploy-Guide) in the Calamares wiki for more details.
- *QML files* Most parts of the user-interface in Calamares can be
  done in two ways: as QWidgets and as QML. The QML UI offers more
  opportunities for designers to produce a unique experience.
  There are sample QML files compiled in to Calamares for a
  basic setup, but an alternative can be selected just by putting
  suitably-named QML files in the Calamares data directory.

  This applies to the navigation and progress-panels, too.

  See the [deployment guide](https://github.com/calamares/calamares/wiki/Deploy-Guide) in the Calamares wiki for more details.
- *Stylesheets* can be applied to some -- or most -- of the QWidgets
  parts of Calamares.

  See the [styling paragraph](https://github.com/calamares/calamares/wiki/Deploy-Guide#styling-calamares) of the deployment guide for more details.

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

The slideshow which is configured in the branding files can have
one of two "API styles".

- Version 1 is loaded when the slideshow starts. If the slideshow is
  large, or contains remote content, then this may be slow.
  The loading time may be visible as a "white flash" as the
  QML component is displayed with no background until the
  slideshow is loaded.
- Version 2 is loaded asynchronously from the moment Calamares is
  started. This may delay startup a little, but appears more
  responsive overall.

If the slideshow QML defines functions
`onActivate()` and `onLeave()` then those functions
are called when the slideshow becomes visible and when the installation is finished.
These can be used to start and stop timers or sound effects or
whatever.

In addition, if the slideshow QML defines a property
`activatedInCalamares` then it is set to `true`
when the slideshow becomes visible, and to `false` when
the installation is finished. This can also be used to
start timers, etc. The standard `Presentation.qml` included with
Calamares has such a property.

A slideshow (`show.qml`) can be entirely independent, with bespoke code,
or it can make use of files shipped as part of Calamares: a *Presentation* and
a *Slide* element (and some others). There are also Calamares internals which
can be used from QML:
- `import calamares.slideshow 1.0` for the standard QML slideshow (e.g. *Presentation* element;
  use *Slide* with this or write an API-equivalent element such as the one in `image-slideshow/`).
- `import io.calamares.ui 1.0` for a *Branding* object which has an API to
  get colors and strings that are used elsewhere in Calamares (e.g. to make the
  slide background the same as the background defined in `branding.desc`).


## Modules

> Modules extend the **functionality** of Calamares for your distro

This repository contains examples of a C++ job module (no UI,
runs in the *exec* phase) and a C++ view module (with UI if
listed in the *show* phase, and may run jobs if listed in the
*exec*  phase) and a Python job module (no UI, runs in the *exec*
phase).

### Example Modules

- [filekeeper](modules/filekeeper/CMakeLists.txt) is a C++ **job** module
  to copy files from the host (live) system to the target system at
  the end of installation, like logfiles. (This module is made obsolete
  by the *preservefiles* module included with Calamares proper)
- [freebsddisk](modules/freebsddisk/CMakeLists.txt) is a C++ **view**
  module with a QML-based UI. It has no actual functionality, and serves
  as a test that view modules can be built out-of-tree.
- [slowpython](modules/slowpython/module.desc) is a Python **job**
  module that just serves to slow down an installation by delaying
  a configurable (default 30 seconds) amount of time.

### Functional Modules

- [mobile](modules/mobile/CMakeLists.txt) is a QML **view** that
  takes over a number of other view steps. It is specific to
  mobile phone use, and as of writing used by
  [postmarketOS](https://postmarketos.org) and
  [Mobian](https://mobian-project.org/).  Among other things, it
  allows to set up full disk encryption and to configure the
  default user's password.  Read the
  [on-device installer](https://wiki.postmarketos.org/wiki/On-device_installer)
  article for more information.

### CMake Preparation

The single macro `calamares_add_module_subdirectory()`
does all the work. A C++ module will be recognized by
the presence of a `CMakeLists.txt` in the subdirectory,
while a Python module has a `module.desc` file.


### C++ Modules

A C++ module can use the CMake macro `calamares_add_plugin()`
to list sources, resources, UI files, libraries to link, etc.
This supports both job modules and view modules through
the *TYPE* parameter of the macro.

The API is documented in the `Job.h` and `ViewModule.h`
(there are subclasses for specific kinds of viewmodules)
header files, and in the
[developer guide](https://github.com/calamares/calamares/wiki/Develop-Guide).

### Python Modules

The Python module needs a `module.desc` and a Python file,
usually called `main.py` which defines a `run()` function.

The API is loosely documented in the
[developer guide](https://github.com/calamares/calamares/wiki/Develop-Guide).
