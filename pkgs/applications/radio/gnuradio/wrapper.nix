{ lib
, stdenv
# The unwrapped gnuradio derivation
, unwrapped
# If it's a minimal build, we don't want to wrap it with lndir and
# wrapProgram..
, doWrap ? true
# For the wrapper
, makeWrapper
# For lndir
, xorg
# To define a the gnuradio.pkgs scope
, newScope
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
  # We don't check if `python-support` feature is on, as it's unlikely someone
  # may wish to wrap GR without python support.
  pythonPkgs = extraPythonPackages
    ++ [ (unwrapped.python.pkgs.toPythonModule unwrapped) ]
    # Add the extraPackages as python modules as well
    ++ (builtins.map unwrapped.python.pkgs.toPythonModule extraPackages)
    ++ lib.flatten (lib.mapAttrsToList (
      feat: info: (
        if unwrapped.hasFeature feat then
          (if builtins.hasAttr "pythonRuntime" info then info.pythonRuntime else [])
        else
          []
      )
      ) unwrapped.featuresInfo)
  ;
  pythonEnv = unwrapped.python.withPackages(ps: pythonPkgs);

  name = (lib.appendToName "wrapped" unwrapped).name;
  makeWrapperArgs = builtins.concatStringsSep " " ([
  ]
    # Emulating wrapGAppsHook & wrapQtAppsHook working together
    ++ lib.optionals (
      (unwrapped.hasFeature "gnuradio-companion")
      || (unwrapped.hasFeature "gr-qtgui")
      ) [
      "--prefix" "XDG_DATA_DIRS" ":" "$out/share"
      "--prefix" "XDG_DATA_DIRS" ":" "$out/share/gsettings-schemas/${name}"
      "--prefix" "XDG_DATA_DIRS" ":" "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}"
      "--prefix" "XDG_DATA_DIRS" ":" "${hicolor-icon-theme}/share"
      # Needs to run `gsettings` on startup, see:
      # https://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg1764890.html
      "--prefix" "PATH" ":" "${lib.getBin glib}/bin"
    ]
    ++ lib.optionals (unwrapped.hasFeature "gnuradio-companion") [
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
    ++ lib.optionals (unwrapped.hasFeature "gr-qtgui")
      # 3.7 builds with qt4
      (if lib.versionAtLeast unwrapped.versionAttr.major "3.8" then
        [
          "--prefix" "QT_PLUGIN_PATH" ":"
          "${
            lib.makeSearchPath
            unwrapped.qt.qtbase.qtPluginPrefix
            (builtins.map lib.getBin [
              unwrapped.qt.qtbase
              unwrapped.qt.qtwayland
            ])
          }"
          "--prefix" "QML2_IMPORT_PATH" ":"
          "${
            lib.makeSearchPath
            unwrapped.qt.qtbase.qtQmlPrefix
            (builtins.map lib.getBin [
              unwrapped.qt.qtbase
              unwrapped.qt.qtwayland
            ])
          }"
        ]
      else
        # Add here qt4 related environment for 3.7?
        [

        ]
      )
    ++ extraMakeWrapperArgs
  );

  packages = import ../../../top-level/gnuradio-packages.nix {
    inherit lib stdenv newScope;
    gnuradio = unwrapped;
  };
  passthru = unwrapped.passthru // {
    inherit
      pythonEnv
      pythonPkgs
      unwrapped
    ;
    pkgs = packages;
  };
  self = if doWrap then
    stdenv.mkDerivation {
      inherit name passthru;
      buildInputs = [
        makeWrapper
        xorg.lndir
      ];
      buildCommand = ''
        mkdir $out
        cd $out
        lndir -silent ${unwrapped}
        ${lib.optionalString
          (extraPackages != [])
          (builtins.concatStringsSep "\n"
            (builtins.map (pkg: ''
              if [[ -d ${lib.getBin pkg}/bin/ ]]; then
                lndir -silent ${pkg}/bin ./bin
              fi
            '') extraPackages)
          )
        }
        for i in $out/bin/*; do
          if [[ ! -x "$i" ]]; then
            continue
          fi
          cp -L "$i" "$i".tmp
          mv -f "$i".tmp "$i"
          if head -1 "$i" | grep -q ${unwrapped.python}; then
            substituteInPlace "$i" \
              --replace ${unwrapped.python} ${pythonEnv}
          fi
          wrapProgram "$i" ${makeWrapperArgs}
        done
      '';
      inherit (unwrapped) meta;
    }
  else
    unwrapped.overrideAttrs(_: {
      inherit passthru;
    })
  ;
in self
