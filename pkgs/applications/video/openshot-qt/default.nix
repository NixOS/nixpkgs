{stdenv, fetchurl, fetchFromGitHub, callPackage, makeWrapper, doxygen
, ffmpeg, python3Packages, qt55}:

with stdenv.lib;

let
  libopenshot = callPackage ./libopenshot.nix {};
in
stdenv.mkDerivation rec {
  name = "openshot-qt-${version}";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "v${version}";
    sha256 = "1s4b61fd8cyjy8kvc25mqd97dkxx6gqmz02i42rrcriz51pw8wgh";
  };

  buildInputs = [doxygen python3Packages.python makeWrapper ffmpeg];

  propagatedBuildInputs = [
    qt55.qtbase
    qt55.qtmultimedia
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
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${libopenshot}):$(toPythonPath ${python3Packages.pyqt5}):$(toPythonPath ${python3Packages.sip}):$(toPythonPath ${python3Packages.httplib2}):$PYTHONPATH"
  '';

  doCheck = false;

  meta = {
    homepage = "http://openshot.org/";
    description = "Free, open-source video editor";
    license = licenses.gpl3Plus;
    maintainers = [maintainers.tohl];
    platforms = platforms.linux;
  };
}
