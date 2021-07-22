{ lib
, fetchFromGitHub
, buildPythonApplication
, wrapGAppsHook
, cairo
, cairocffi
, dateutil
, dbus-python
, glib
, gobject-introspection
, libnotify
, libpulseaudio
, libxcb
, mpd2
, pango
, pkg-config
, psutil
, pygobject3
, pyxdg
, setuptools
, setuptools_scm
, xcbutilcursor
, xcffib

, dbus
, pytest
, xcalc
, xclock
, xeyes
, xorgserver
, xterm
, xvfb-run
}:
let cairocffi-xcffib = cairocffi.override {
    withXcffib = true;
  };
in
buildPythonApplication rec {
  name = "qtile-${version}";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "qtile";
    repo = "qtile";
    rev = "v${version}";
    sha256 = "0n1scjrk9pwjjivpsvp8gx2yqssk79hgsx5d0dlay9kk7bzvsx0w";
  };

  patches = [
    ./0001-Substitution-vars-for-absolute-paths.patch
    ./0002-Restore-PATH-and-PYTHONPATH.patch
    ./0003-Restart-executable.patch
    ./0004-Fix-test-propgated-PYTHONPATH-in-Popen.patch
  ];

  postPatch = ''
    substituteInPlace libqtile/core/manager.py --subst-var-by out $out
    substituteInPlace libqtile/pangocffi.py \
      --subst-var-by glib ${glib.out} \
      --subst-var-by pango ${pango.out}
    substituteInPlace libqtile/backend/x11/xcursors.py --subst-var-by xcb-cursor ${xcbutilcursor}
    patchShebangs ./scripts/xephyr
  '';

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];
  buildInputs = [ glib libxcb cairo pango xcffib libpulseaudio ];
  propagatedBuildInputs = [
    cairocffi-xcffib
    dateutil
    dbus-python
    gobject-introspection
    libnotify
    mpd2
    psutil
    pygobject3
    pyxdg
    setuptools
    setuptools-scm
    xcffib
  ];

  preBuild = ''
    ./scripts/ffibuild
  '';

  postInstall = ''
    echo $PYTHONPATH
    wrapProgram $out/bin/qtile \
      --run 'export QTILE_WRAPPER=$0' \
      --run 'export QTILE_SAVED_PYTHONPATH=$PYTHONPATH' \
      --run 'export QTILE_SAVED_PATH=$PATH'
  '';

  doCheck = true;
  checkInputs = [
    dbus
    libnotify
    pytest
    xcalc
    xcffib
    xclock
    xeyes
    xorgserver
    xterm
    xvfb-run
  ];

  checkPhase = ''
    mkdir cache
    export HOME=$(pwd)
    export XDG_CACHE_HOME="$(pwd)/cache"
    export SCREEN_SIZE=1920x1080
    xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
     ./scripts/xephyr &
    pytest
  '';

  meta = with lib; {
    homepage = "http://www.qtile.org/";
    license = licenses.mit;
    description = "A small, flexible, scriptable tiling window manager written in Python";
    platforms = platforms.linux;
    maintainers = with maintainers; [ kamilchm shamilton ];
  };
}
