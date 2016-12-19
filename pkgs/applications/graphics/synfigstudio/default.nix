{ stdenv, fetchFromGitHub, boost, cairo, fontsConf, gettext, glibmm, gtk3, gtkmm3
, libjack2, libsigcxx, libtool, libxmlxx, makeWrapper, mlt-qt5, pango, pkgconfig
, imagemagick, intltool, autoreconfHook, which, defaultIconTheme
}:

let
  version = "1.0.2";

  ETL = stdenv.mkDerivation rec {
    name = "ETL-0.04.19";

    src = fetchFromGitHub {
       repo   = "synfig";
       owner  = "synfig";
       rev    = version;
       sha256 = "09ldkvzczqvb1yvlibd62y56dkyprxlr0w3rk38rcs7jnrhj2cqc";
    };

    postUnpack = "sourceRoot=\${sourceRoot}/ETL/";

    buildInputs = [ autoreconfHook ];
  };

  synfig = stdenv.mkDerivation rec {
    name = "synfig-${version}";

    src = fetchFromGitHub {
       repo   = "synfig";
       owner  = "synfig";
       rev    = version;
       sha256 = "09ldkvzczqvb1yvlibd62y56dkyprxlr0w3rk38rcs7jnrhj2cqc";
    };

    postUnpack = "sourceRoot=\${sourceRoot}/synfig-core/";

    configureFlags = [
      "--with-boost=${boost.dev}"
      "--with-boost-libdir=${boost.out}/lib"
    ];

    buildInputs = [
      ETL boost cairo gettext glibmm mlt-qt5 libsigcxx libxmlxx pango
      pkgconfig autoreconfHook
    ];
  };
in
stdenv.mkDerivation rec {
  name = "synfigstudio-${version}";

  src = fetchFromGitHub {
     repo   = "synfig";
     owner  = "synfig";
     rev    = version;
     sha256 = "09ldkvzczqvb1yvlibd62y56dkyprxlr0w3rk38rcs7jnrhj2cqc";
  };

  postUnpack = "sourceRoot=\${sourceRoot}/synfig-studio/";

  postPatch = ''
    for i in \
      brushlib/brushlib.hpp \
      gui/canvasview.cpp \
      gui/compview.cpp \
      gui/docks/dock_canvasspecific.cpp \
      gui/docks/dock_children.cpp \
      gui/docks/dock_curves.cpp \
      gui/docks/dock_history.cpp \
      gui/docks/dock_keyframes.cpp \
      gui/docks/dock_layergroups.cpp \
      gui/docks/dock_layers.cpp \
      gui/docks/dock_metadata.cpp \
      gui/docks/dock_params.cpp \
      gui/docks/dock_timetrack.cpp \
      gui/docks/dock_toolbox.cpp \
      gui/docks/dockable.cpp \
      gui/docks/dockdialog.cpp \
      gui/docks/dockmanager.h \
      gui/duck.h \
      gui/duckmatic.cpp \
      gui/duckmatic.h \
      gui/instance.cpp \
      gui/instance.h \
      gui/states/state_stroke.h \
      gui/states/state_zoom.cpp \
      gui/widgets/widget_curves.cpp \
      gui/workarea.cpp \
      gui/workarearenderer/workarearenderer.h \
      synfigapp/action_system.h \
      synfigapp/canvasinterface.h \
      synfigapp/instance.h \
      synfigapp/main.h \
      synfigapp/uimanager.h
    do
      substituteInPlace src/"$i" --replace '#include <sigc++/object.h>' '#include <sigc++/sigc++.h>'
      substituteInPlace src/"$i" --replace '#include <sigc++/hide.h>' '#include <sigc++/adaptors/hide.h>'
      substituteInPlace src/"$i" --replace '#include <sigc++/retype.h>' '#include <sigc++/adaptors/retype.h>'
    done
  '';

  preConfigure = "./bootstrap.sh";

  buildInputs = [
    ETL boost cairo gettext glibmm gtk3 gtkmm3 imagemagick intltool
    libjack2 libsigcxx libxmlxx makeWrapper mlt-qt5 pkgconfig
    synfig autoreconfHook which defaultIconTheme
  ];

  postInstall = ''
    wrapProgram "$out/bin/synfigstudio" \
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A 2D animation program";
    homepage = http://www.synfig.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
