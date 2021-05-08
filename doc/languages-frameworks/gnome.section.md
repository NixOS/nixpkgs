# GNOME {#sec-language-gnome}

## Packaging GNOME applications {#ssec-gnome-packaging}

Programs in the GNOME universe are written in various languages but they all use GObject-based libraries like GLib, GTK or GStreamer. These libraries are often modular, relying on looking into certain directories to find their modules. However, due to Nix’s specific file system organization, this will fail without our intervention. Fortunately, the libraries usually allow overriding the directories through environment variables, either natively or thanks to a patch in nixpkgs. [Wrapping](#fun-wrapProgram) the executables to ensure correct paths are available to the application constitutes a significant part of packaging a modern desktop application. In this section, we will describe various modules needed by such applications, environment variables needed to make the modules load, and finally a script that will do the work for us.

### Settings {#ssec-gnome-settings}

[GSettings](https://developer.gnome.org/gio/stable/GSettings.html) API is often used for storing settings. GSettings schemas are required, to know the type and other metadata of the stored values. GLib looks for `glib-2.0/schemas/gschemas.compiled` files inside the directories of `XDG_DATA_DIRS`.

On Linux, GSettings API is implemented using [dconf](https://wiki.gnome.org/Projects/dconf) backend. You will need to add `dconf` GIO module to `GIO_EXTRA_MODULES` variable, otherwise the `memory` backend will be used and the saved settings will not be persistent.

Last you will need the dconf database D-Bus service itself. You can enable it using `programs.dconf.enable`.

Some applications will also require `gsettings-desktop-schemas` for things like reading proxy configuration or user interface customization. This dependency is often not mentioned by upstream, you should grep for `org.gnome.desktop` and `org.gnome.system` to see if the schemas are needed.

### GdkPixbuf loaders {#ssec-gnome-gdk-pixbuf-loaders}

GTK applications typically use [GdkPixbuf](https://developer.gnome.org/gdk-pixbuf/stable/) to load images. But `gdk-pixbuf` package only supports basic bitmap formats like JPEG, PNG or TIFF, requiring to use third-party loader modules for other formats. This is especially painful since GTK itself includes SVG icons, which cannot be rendered without a loader provided by `librsvg`.

Unlike other libraries mentioned in this section, GdkPixbuf only supports a single value in its controlling environment variable `GDK_PIXBUF_MODULE_FILE`. It is supposed to point to a cache file containing information about the available loaders. Each loader package will contain a `lib/gdk-pixbuf-2.0/2.10.0/loaders.cache` file describing the default loaders in `gdk-pixbuf` package plus the loader contained in the package itself. If you want to use multiple third-party loaders, you will need to create your own cache file manually. Fortunately, this is pretty rare as [not many loaders exist](https://gitlab.gnome.org/federico/gdk-pixbuf-survey/blob/master/src/modules.md).

`gdk-pixbuf` contains [a setup hook](#ssec-gnome-hooks-gdk-pixbuf) that sets `GDK_PIXBUF_MODULE_FILE` from dependencies but as mentioned in further section, it is pretty limited. Loaders should propagate this setup hook.

### Icons {#ssec-gnome-icons}

When an application uses icons, an icon theme should be available in `XDG_DATA_DIRS` during runtime. The package for the default, icon-less [hicolor-icon-theme](https://www.freedesktop.org/wiki/Software/icon-theme/) (should be propagated by every icon theme) contains [a setup hook](#ssec-gnome-hooks-hicolor-icon-theme) that will pick up icon themes from `buildInputs` and pass it to our wrapper. Unfortunately, relying on that would mean every user has to download the theme included in the package expression no matter their preference. For that reason, we leave the installation of icon theme on the user. If you use one of the desktop environments, you probably already have an icon theme installed.

To avoid costly file system access when locating icons, GTK, [as well as Qt](https://woboq.com/blog/qicon-reads-gtk-icon-cache-in-qt57.html), can rely on `icon-theme.cache` files from the themes' top-level directories. These files are generated using `gtk-update-icon-cache`, which is expected to be run whenever an icon is added or removed to an icon theme (typically an application icon into `hicolor` theme) and some programs do indeed run this after icon installation. However, since packages are installed into their own prefix by Nix, this would lead to conflicts. For that reason, `gtk3` provides a [setup hook](#ssec-gnome-hooks-gtk-drop-icon-theme-cache) that will clean the file from installation. Since most applications only ship their own icon that will be loaded on start-up, it should not affect them too much. On the other hand, icon themes are much larger and more widely used so we need to cache them. Because we recommend installing icon themes globally, we will generate the cache files from all packages in a profile using a NixOS module. You can enable the cache generation using `gtk.iconCache.enable` option if your desktop environment does not already do that.

### Packaging icon themes {#ssec-icon-theme-packaging}

Icon themes may inherit from other icon themes. The inheritance is specified using the `Inherits` key in the `index.theme` file distributed with the icon theme. According to the [icon theme specification](https://specifications.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html), icons not provided by the theme are looked for in its parent icon themes. Therefore the parent themes should be installed as dependencies for a more complete experience regarding the icon sets used.

The package `hicolor-icon-theme` provides a setup hook which makes symbolic links for the parent themes into the directory `share/icons` of the current theme directory in the nix store, making sure they can be found at runtime. For that to work the packages providing parent icon themes should be listed as propagated build dependencies, together with `hicolor-icon-theme`.

Also make sure that `icon-theme.cache` is installed for each theme provided by the package, and set `dontDropIconThemeCache` to `true` so that the cache file is not removed by the `gtk3` setup hook.

### GTK Themes {#ssec-gnome-themes}

Previously, a GTK theme needed to be in `XDG_DATA_DIRS`. This is no longer necessary for most programs since GTK incorporated Adwaita theme. Some programs (for example, those designed for [elementary HIG](https://elementary.io/docs/human-interface-guidelines#human-interface-guidelines)) might require a special theme like `pantheon.elementary-gtk-theme`.

### GObject introspection typelibs {#ssec-gnome-typelibs}

[GObject introspection](https://wiki.gnome.org/Projects/GObjectIntrospection) allows applications to use C libraries in other languages easily. It does this through `typelib` files searched in `GI_TYPELIB_PATH`.

### Various plug-ins {#ssec-gnome-plugins}

If your application uses [GStreamer](https://gstreamer.freedesktop.org/) or [Grilo](https://wiki.gnome.org/Projects/Grilo), you should set `GST_PLUGIN_SYSTEM_PATH_1_0` and `GRL_PLUGIN_PATH`, respectively.

## Onto `wrapGAppsHook` {#ssec-gnome-hooks}

Given the requirements above, the package expression would become messy quickly:

```nix
preFixup = ''
  for f in $(find $out/bin/ $out/libexec/ -type f -executable); do
    wrapProgram "$f" \
      --prefix GIO_EXTRA_MODULES : "${getLib dconf}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$out/share" \
      --prefix XDG_DATA_DIRS : "$out/share/gsettings-schemas/${name}" \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}" \
      --prefix XDG_DATA_DIRS : "${hicolor-icon-theme}/share" \
      --prefix GI_TYPELIB_PATH : "${lib.makeSearchPath "lib/girepository-1.0" [ pango json-glib ]}"
  done
'';
```

Fortunately, there is [`wrapGAppsHook`]{#ssec-gnome-hooks-wrapgappshook}. It works in conjunction with other setup hooks that populate environment variables, and it will then wrap all executables in `bin` and `libexec` directories using said variables.

For convenience, it also adds `dconf.lib` for a GIO module implementing a GSettings backend using `dconf`, `gtk3` for GSettings schemas, and `librsvg` for GdkPixbuf loader to the closure. There is also [`wrapGAppsHook4`]{#ssec-gnome-hooks-wrapgappshook4}, which replaces GTK 3 with GTK 4. And in case you are packaging a program without a graphical interface, you might want to use [`wrapGAppsNoGuiHook`]{#ssec-gnome-hooks-wrapgappsnoguihook}, which runs the same script as `wrapGAppsHook` but does not bring `gtk3` and `librsvg` into the closure.

- `wrapGAppsHook` itself will add the package’s `share` directory to `XDG_DATA_DIRS`.

- []{#ssec-gnome-hooks-glib} `glib` setup hook will populate `GSETTINGS_SCHEMAS_PATH` and then `wrapGAppsHook` will prepend it to `XDG_DATA_DIRS`.

- []{#ssec-gnome-hooks-gdk-pixbuf} `gdk-pixbuf` setup hook will populate `GDK_PIXBUF_MODULE_FILE` with the path to biggest `loaders.cache` file from the dependencies containing [GdkPixbuf loaders](ssec-gnome-gdk-pixbuf-loaders). This works fine when there are only two packages containing loaders (`gdk-pixbuf` and e.g. `librsvg`) – it will choose the second one, reasonably expecting that it will be bigger since it describes extra loader in addition to the default ones. But when there are more than two loader packages, this logic will break. One possible solution would be constructing a custom cache file for each package containing a program like `services/x11/gdk-pixbuf.nix` NixOS module does. `wrapGAppsHook` copies the `GDK_PIXBUF_MODULE_FILE` environment variable into the produced wrapper.

- []{#ssec-gnome-hooks-gtk-drop-icon-theme-cache} One of `gtk3`’s setup hooks will remove `icon-theme.cache` files from package’s icon theme directories to avoid conflicts. Icon theme packages should prevent this with `dontDropIconThemeCache = true;`.

- []{#ssec-gnome-hooks-dconf} `dconf.lib` is a dependency of `wrapGAppsHook`, which then also adds it to the `GIO_EXTRA_MODULES` variable.

- []{#ssec-gnome-hooks-hicolor-icon-theme} `hicolor-icon-theme`’s setup hook will add icon themes to `XDG_ICON_DIRS` which is prepended to `XDG_DATA_DIRS` by `wrapGAppsHook`.

- []{#ssec-gnome-hooks-gobject-introspection} `gobject-introspection` setup hook populates `GI_TYPELIB_PATH` variable with `lib/girepository-1.0` directories of dependencies, which is then added to wrapper by `wrapGAppsHook`. It also adds `share` directories of dependencies to `XDG_DATA_DIRS`, which is intended to promote GIR files but it also [pollutes the closures](https://github.com/NixOS/nixpkgs/issues/32790) of packages using `wrapGAppsHook`.

  ::: warning
  The setup hook [currently](https://github.com/NixOS/nixpkgs/issues/56943) does not work in expressions with `strictDeps` enabled, like Python packages. In those cases, you will need to disable it with `strictDeps = false;`.
  :::

- []{#ssec-gnome-hooks-gst-grl-plugins} Setup hooks of `gst_all_1.gstreamer` and `grilo` will populate the `GST_PLUGIN_SYSTEM_PATH_1_0` and `GRL_PLUGIN_PATH` variables, respectively, which will then be added to the wrapper by `wrapGAppsHook`.

You can also pass additional arguments to `makeWrapper` using `gappsWrapperArgs` in `preFixup` hook:

```nix
preFixup = ''
  gappsWrapperArgs+=(
    # Thumbnailers
    --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
    --prefix XDG_DATA_DIRS : "${librsvg}/share"
    --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
  )
'';
```

## Updating GNOME packages {#ssec-gnome-updating}

Most GNOME package offer [`updateScript`](#var-passthru-updateScript), it is therefore possible to update to latest source tarball by running `nix-shell maintainers/scripts/update.nix --argstr package gnome.nautilus` or even en masse with `nix-shell maintainers/scripts/update.nix --argstr path gnome`. Read the package’s `NEWS` file to see what changed.

## Frequently encountered issues {#ssec-gnome-common-issues}

#### `GLib-GIO-ERROR **: 06:04:50.903: No GSettings schemas are installed on the system` {#ssec-gnome-common-issues-no-schemas}

There are no schemas available in `XDG_DATA_DIRS`. Temporarily add a random package containing schemas like `gsettings-desktop-schemas` to `buildInputs`. [`glib`](#ssec-gnome-hooks-glib) and [`wrapGAppsHook`](#ssec-gnome-hooks-wrapgappshook) setup hooks will take care of making the schemas available to application and you will see the actual missing schemas with the [next error](#ssec-gnome-common-issues-missing-schema). Or you can try looking through the source code for the actual schemas used.

#### `GLib-GIO-ERROR **: 06:04:50.903: Settings schema ‘org.gnome.foo’ is not installed` {#ssec-gnome-common-issues-missing-schema}

Package is missing some GSettings schemas. You can find out the package containing the schema with `nix-locate org.gnome.foo.gschema.xml` and let the hooks handle the wrapping as [above](#ssec-gnome-common-issues-no-schemas).

#### When using `wrapGAppsHook` with special derivers you can end up with double wrapped binaries. {#ssec-gnome-common-issues-double-wrapped}

This is because derivers like `python.pkgs.buildPythonApplication` or `qt5.mkDerivation` have setup-hooks automatically added that produce wrappers with makeWrapper. The simplest way to workaround that is to disable the `wrapGAppsHook` automatic wrapping with `dontWrapGApps = true;` and pass the arguments it intended to pass to makeWrapper to another.

In the case of a Python application it could look like:

```nix
python3.pkgs.buildPythonApplication {
  pname = "gnome-music";
  version = "3.32.2";

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
    ...
  ];

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by buildPython*
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
}
```

And for a QT app like:

```nix
mkDerivation {
  pname = "calibre";
  version = "3.47.0";

  nativeBuildInputs = [
    wrapGAppsHook
    qmake
    ...
  ];

  dontWrapGApps = true;

  # Arguments to be passed to `makeWrapper`, only used by qt5’s mkDerivation
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
}
```

#### I am packaging a project that cannot be wrapped, like a library or GNOME Shell extension. {#ssec-gnome-common-issues-unwrappable-package}

You can rely on applications depending on the library setting the necessary environment variables but that is often easy to miss. Instead we recommend to patch the paths in the source code whenever possible. Here are some examples:

- []{#ssec-gnome-common-issues-unwrappable-package-gnome-shell-ext} [Replacing a `GI_TYPELIB_PATH` in GNOME Shell extension](https://github.com/NixOS/nixpkgs/blob/7bb8f05f12ca3cff9da72b56caa2f7472d5732bc/pkgs/desktops/gnome-3/core/gnome-shell-extensions/default.nix#L21-L24) – we are using `substituteAll` to include the path to a typelib into a patch.

- []{#ssec-gnome-common-issues-unwrappable-package-gsettings} The following examples are hardcoding GSettings schema paths. To get the schema paths we use the functions

  * `glib.getSchemaPath` Takes a nix package attribute as an argument.

  * `glib.makeSchemaPath` Takes a package output like `$out` and a derivation name. You should use this if the schemas you need to hardcode are in the same derivation.

  []{#ssec-gnome-common-issues-unwrappable-package-gsettings-vala} [Hard-coding GSettings schema path in Vala plug-in (dynamically loaded library)](https://github.com/NixOS/nixpkgs/blob/7bb8f05f12ca3cff9da72b56caa2f7472d5732bc/pkgs/desktops/pantheon/apps/elementary-files/default.nix#L78-L86) – here, `substituteAll` cannot be used since the schema comes from the same package preventing us from pass its path to the function, probably due to a [Nix bug](https://github.com/NixOS/nix/issues/1846).

  []{#ssec-gnome-common-issues-unwrappable-package-gsettings-c} [Hard-coding GSettings schema path in C library](https://github.com/NixOS/nixpkgs/blob/29c120c065d03b000224872251bed93932d42412/pkgs/development/libraries/glib-networking/default.nix#L31-L34) – nothing special other than using [Coccinelle patch](https://github.com/NixOS/nixpkgs/pull/67957#issuecomment-527717467) to generate the patch itself.

#### I need to wrap a binary outside `bin` and `libexec` directories. {#ssec-gnome-common-issues-weird-location}

You can manually trigger the wrapping with `wrapGApp` in `preFixup` phase. It takes a path to a program as a first argument; the remaining arguments are passed directly to [`wrapProgram`](#fun-wrapProgram) function.
