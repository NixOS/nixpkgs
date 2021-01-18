{ lib
, stdenv
, unwrapped
, makeWrapper
# For lndir
, xorg
# For Emulating wrapGAppsHook
, gsettings-desktop-schemas
, glib
, hicolor-icon-theme
, pango
, json-glib
, dconf
, gobject-introspection
, librsvg
, gdk-pixbuf
, harfbuzz
, at-spi2-core
, atk
# For Adding additional GRC blocks
, extraPackages ? []
# For Adding additional python packaages
, extraPythonPackages ? []
# Allow to add whatever you want to the wrapper
, extraMakeWrapperArgs ? []
}:

let
  pythonPkgs = extraPythonPackages
    # Add the extraPackages as python modules as well
    ++ (builtins.map unwrapped.python.pkgs.toPythonModule extraPackages)
    ++ lib.flatten (lib.mapAttrsToList (
      feat: info: (
        if unwrapped.hasFeature feat unwrapped.features then
          (if builtins.hasAttr "pythonRuntime" info then info.pythonRuntime else [])
        else
          []
      )
      ) unwrapped.featuresInfo)
    ++ lib.optionals (unwrapped.hasFeature "python-support" unwrapped.features) [
      # Add unwrapped itself as a python module
      (unwrapped.python.pkgs.toPythonModule unwrapped)
    ]
  ;
  python3Env = unwrapped.python.withPackages(ps: pythonPkgs);

  name = (lib.appendToName "wrapped" unwrapped).name;
  makeWrapperArgs = builtins.concatStringsSep " " ([
  ]
    # Emulating wrapGAppsHook & wrapQtAppsHook working together
    ++ lib.optionals (
      (unwrapped.hasFeature "gnuradio-companion" unwrapped.features)
      || (unwrapped.hasFeature "gr-qtgui" unwrapped.features)
      ) [
      "--prefix" "XDG_DATA_DIRS" ":" "$out/share"
      "--prefix" "XDG_DATA_DIRS" ":" "$out/share/gsettings-schemas/${name}"
      "--prefix" "XDG_DATA_DIRS" ":" "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
      "--prefix" "XDG_DATA_DIRS" ":" "${hicolor-icon-theme}/share"
      # Needs to run `gsettings` on startup, see:
      # https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1764890.html
      "--prefix" "PATH" ":" "${lib.getBin glib}/bin"
    ]
    ++ lib.optionals (unwrapped.hasFeature "gnuradio-companion" unwrapped.features) [
      "--set" "GDK_PIXBUF_MODULE_FILE" "${librsvg}/${gdk-pixbuf.moduleDir}.cache"
      "--prefix" "GIO_EXTRA_MODULES" ":" "${lib.getLib dconf}/lib/gio/modules"
      "--prefix" "XDG_DATA_DIRS" ":" "${unwrapped.gtk}/share"
      "--prefix" "XDG_DATA_DIRS" ":" "${unwrapped.gtk}/share/gsettings-schemas/${unwrapped.gtk.name}"
      "--prefix" "GI_TYPELIB_PATH" ":" "${lib.makeSearchPath "lib/girepository-1.0" [
        unwrapped.gtk
        gsettings-desktop-schemas
        atk
        # From some reason, if .out is not used, .bin is used, and we want
        # what's in `.out`.
        pango.out
        gdk-pixbuf
        json-glib
        harfbuzz
        librsvg
        gobject-introspection
        at-spi2-core
      ]}"
    ]
    ++ lib.optionals (extraPackages != []) [
      "--prefix" "GRC_BLOCKS_PATH" ":" "${lib.makeSearchPath "share/gnuradio/grc/blocks" extraPackages}"
    ]
    ++ lib.optionals (unwrapped.hasFeature "gr-qtgui" unwrapped.features)
      # 3.7 builds with qt4
      (if unwrapped.versionAttr.major == "3.8" then
        [
          "--prefix" "QT_PLUGIN_PATH" ":"
          "${lib.getBin unwrapped.qt.qtbase}/${unwrapped.qt.qtbase.qtPluginPrefix}"
          "--prefix" "QML2_IMPORT_PATH" ":"
          "${lib.getBin unwrapped.qt.qtbase}/${unwrapped.qt.qtbase.qtQmlPrefix}"
        ]
      else
        # TODO: Add here qt4 related environment for 3.7?
        [

        ]
      )
    ++ extraMakeWrapperArgs
  );
in
stdenv.mkDerivation {
  inherit name;

  buildInputs = [
    makeWrapper
    xorg.lndir
  ];

  passthru = {
    inherit python3Env pythonPkgs unwrapped;
  };

  buildCommand = ''
    mkdir $out
    cd $out
    lndir -silent ${unwrapped}
    for i in $out/bin/*; do
      if [[ ! -x "$i" ]]; then
        continue
      fi
      cp -L "$i" "$i".tmp
      mv -f "$i".tmp "$i"
      if head -1 "$i" | grep -q ${unwrapped.python}; then
        substituteInPlace "$i" \
          --replace ${unwrapped.python} ${python3Env}
      fi
      wrapProgram "$i" ${makeWrapperArgs}
    done
  '';

  inherit (unwrapped) meta;
}
