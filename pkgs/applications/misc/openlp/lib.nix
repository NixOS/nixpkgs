# This file contains the base package, some of which is compiled.
# Runtime glue to optinal runtime dependencies is in 'default.nix'.
{ fetchurl, lib, qt5

# python deps
, python, buildPythonPackage
, alembic, beautifulsoup4, chardet, lxml, mako, pyenchant
, pyqt5-webkit, pyxdg, sip4, sqlalchemy, sqlalchemy-migrate
}:

buildPythonPackage rec {
  pname = "openlp";
  version = "2.4.6";

  src = fetchurl {
    url = "https://get.openlp.org/${version}/OpenLP-${version}.tar.gz";
    sha256 = "f63dcf5f1f8a8199bf55e806b44066ad920d26c9cf67ae432eb8cdd1e761fc30";
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
  nativeBuildInputs = [ qt5.qttools ];
  propagatedBuildInputs = [
    alembic
    beautifulsoup4
    chardet
    lxml
    mako
    pyenchant
    pyqt5-webkit
    pyxdg
    sip4
    sqlalchemy
    sqlalchemy-migrate
  ];

  prePatch = ''
    echo 'from vlc import *' > openlp/core/ui/media/vendor/vlc.py
  '';

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
    rm -r $out/${python.sitePackages}/tests
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

      Remark: This pkg only supports sqlite dbs. If you wish to have support for
            mysql or postgresql dbs, or Jenkins, please contact the maintainer.

      Bugs which affect this software packaged in Nixpkgs:

      1. The package must disable checks, because they are lacking the qt env.
         (see pkg source and https://discourse.nixos.org/t/qt-plugin-path-unset-in-test-phase/)
      2. There is a segfault on exit. Not a real problem, according to debug log, everything
         shuts down correctly. Maybe related to https://forums.openlp.org/discussion/3620/crash-on-exit.
         Plan: Wait for OpenLP-3, since it is already in beta 1
         (2021-02-09; news: https://openlp.org/blog/).
    '';
  };
}
