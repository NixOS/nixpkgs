# This file contains the base package, some of which is compiled.
# Runtime glue to optinal runtime dependencies is in 'default.nix'.
{ fetchFromGitLab, lib, qt5

# python deps
, python, pythonPackages, buildPythonPackage
, alembic
, beautifulsoup4
, chardet
, dbus-python
, distro
, flask
, flask-cors
, lxml
, mako
, packaging
, platformdirs
, pyicu
, pymediainfo
, pyenchant
, pytest-runner
, pyqt5
, pyqtwebengine
, qtawesome
, qrcode
, requests
, sqlalchemy
, waitress
, websockets
}:

buildPythonPackage rec {
  pname = "openlp";
  version = "3.1.2";

  src = fetchFromGitLab {
    owner = "openlp";
    repo = pname;
    rev = version;
    hash = "sha256-SdLdgFXTEl1E9zPktnGTzH+qZj7bVZ4QTy1nZuvWc08=";
  };

  doCheck = false;
  # FIXME: checks must be disabled because they are lacking the qt env.
  #        They fail like this, even if built and wrapped with all Qt and
  #        runtime dependencies:
  #
  #     running install tests
  #     qt.qpa.plugin: Could not find the Qt platform plugin "xcb" in ""
  #     This application failed to start because no Qt platform plugin could be initialized. Reinstalling the application may fix this problem.
  #
  #     Available platform plugins are: wayland-egl, wayland, wayland-xcomposite-egl, wayland-xcomposite-glx.
  #
  # See also https://discourse.nixos.org/t/qt-plugin-path-unset-in-test-phase/

  #nativeCheckInputs = [ mock nose ];
  nativeBuildInputs = [ qt5.qttools pytest-runner ];
  propagatedBuildInputs = [
    alembic
    beautifulsoup4
    chardet
    dbus-python
    distro
    flask
    flask-cors
    lxml
    mako
    packaging
    platformdirs
    pyicu
    pymediainfo
    pyenchant
    pyqt5
    pyqtwebengine
    qtawesome
    qrcode
    requests
    sqlalchemy
    waitress
    websockets
  ];

  dontWrapQtApps = true;
  dontWrapGApps = true;
  postInstall = ''
    ( # use subshell because of cd
      tdestdir="$out/i18n"
      mkdir -p "$tdestdir"
      cd ./resources/i18n
      for file in *.ts; do
          lconvert -i "$file" -o "$tdestdir/''${file%%ts}qm"
      done
    )
  '';

  preFixup = ''
    rm -r $out/bin
  '';

  meta = with lib; {
    description = "Free church presentation software";
    homepage = "https://openlp.org/";
    downloadPage = "https://openlp.org/#downloads";
    platforms = platforms.unix;
    license = licenses.gpl2Only;
    maintainers = [ maintainers.jorsn ];

    longDescription = ''
      OpenLP is a free church presentation software.

      Features:

      * Cross platform between Linux, Windows, OS X and FreeBSD
      * Display songs, Bible verses, presentations, images, audio and video
      * Control OpenLP remotely via the Android remote, iOS remote or mobile web browser
      * Quickly and easily import songs from other popular presentation packages
      * Easy enough to use to get up and running in less than 10 minutes

      Remarks:

      1. The web remote is not installed by Nix. It must be installed by OpenLP,
         as described here: https://manual.openlp.org/configure.html#web-remote

      2. This pkg only supports sqlite dbs. If you wish to have support for
         mysql or postgresql dbs, or Jenkins, please contact the maintainer.
    '';
  };
}
