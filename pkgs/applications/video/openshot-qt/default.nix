{stdenv, fetchurl, fetchFromGitHub, callPackage, makeWrapper, doxygen
, ffmpeg, python3Packages, libopenshot, qtbase, qtmultimedia }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "openshot-qt-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "v${version}";
    sha256 = "1cyr5m1n6qcb9bzkhh3v6ka91a6x9c50dl5j0ilrc8vj0mb43g8c";
  };

  buildInputs = [doxygen python3Packages.python makeWrapper ffmpeg];

  propagatedBuildInputs = [
    qtbase
    qtmultimedia
    libopenshot
  ];

  installPhase = ''
    mkdir -p $(toPythonPath $out)
    cp -r src/* $(toPythonPath $out)
    mkdir -p $out/bin
    echo "#/usr/bin/env sh" >$out/bin/openshot-qt
    echo "exec ${python3Packages.python.interpreter} $(toPythonPath $out)/launch.py" >>$out/bin/openshot-qt
    chmod +x $out/bin/openshot-qt
    wrapProgram $out/bin/openshot-qt \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${libopenshot}):$(toPythonPath ${python3Packages.pyqt5}):$(toPythonPath ${python3Packages.sip}):$(toPythonPath ${python3Packages.httplib2}):$(toPythonPath ${python3Packages.pyzmq}):$PYTHONPATH"
  '';

  doCheck = false;

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor";
    license = licenses.gpl3Plus;
    maintainers = [];
    platforms = platforms.linux;
  };
}
