{ stdenv, fetchFromGitHub
, doxygen, python3Packages, ffmpeg, libopenshot
, qtbase, qtmultimedia, makeQtWrapper }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "openshot-qt-${version}";
  version = "2.3.1";

  src = fetchFromGitHub {
    owner = "OpenShot";
    repo = "openshot-qt";
    rev = "v${version}";
    sha256 = "10j3p10q66m9nhzcd8315q1yiqscidkjbm474mllw7c281vacvzw";
  };
    
  buildInputs =
  [ python3Packages.python ffmpeg libopenshot qtbase qtmultimedia ];

  nativeBuildInputs =
  [ doxygen makeQtWrapper ];

  installPhase = ''
    mkdir -p $(toPythonPath $out)
    cp -r src/* $(toPythonPath $out)
    mkdir -p $out/bin
    echo "#/usr/bin/env sh" >$out/bin/openshot-qt
    echo "exec ${python3Packages.python.interpreter} $(toPythonPath $out)/launch.py" >>$out/bin/openshot-qt
    chmod +x $out/bin/openshot-qt
    wrapQtProgram $out/bin/openshot-qt \
      --prefix PYTHONPATH : "$(toPythonPath $out):$(toPythonPath ${libopenshot}):$(toPythonPath ${python3Packages.pyqt5}):$(toPythonPath ${python3Packages.sip}):$(toPythonPath ${python3Packages.httplib2}):$(toPythonPath ${python3Packages.pyzmq}):$PYTHONPATH"
  '';

  doCheck = false;

  meta = {
    homepage = http://openshot.org/;
    description = "Free, open-source video editor";
    longDescription = ''
      OpenShot Video Editor is a free, open-source video editor for Linux.
      OpenShot can take your videos, photos, and music files and help you
      create the film you have always dreamed of. Easily add sub-titles,
      transitions, and effects, and then export your film to DVD, YouTube,
      Vimeo, Xbox 360, and many other common formats.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };
}
