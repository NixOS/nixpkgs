{ stdenv, csound, desktop-file-utils,
  fetchFromGitHub, python, python-qt, qmake,
  qtwebengine, rtmidi, unzip }:

stdenv.mkDerivation rec {
  name = "csound-qt-${version}";
  version = "0.9.6-beta2";

  src = fetchFromGitHub {
    owner = "CsoundQt";
    repo = "CsoundQt";
    rev = "${version}";
    sha256 = "12jv7cvns3wj2npha0mvpn88kkkfsxsvhgzs2wrw04kbrvbhbffi";
  };

  patches = [ ./rtmidipath.patch ];

  nativeBuildInputs = [ qmake qtwebengine ];

  buildInputs = [ csound desktop-file-utils rtmidi unzip ];

  qmakeFlags = [ "qcs.pro" "CONFIG+=rtmidi" "CONFIG+=pythonqt"
                 "CSOUND_INCLUDE_DIR=${csound}/include/csound"
                 "CSOUND_LIBRARY_DIR=${csound}/lib"
                 "RTMIDI_DIR=${rtmidi.src}"
                 "PYTHONQT_SRC_DIR=${python-qt}/lib"
                 "PYTHONQT_LIB_DIR=${python-qt}/lib"
                 "LIBS+=${python-qt}/lib/libPythonQt-Qt5-Python2.7.so"
                 "LIBS+=${python-qt}/lib/libPythonQt_QtAll-Qt5-Python2.7.so"
                 "INCLUDEPATH+=${python-qt}/include/PythonQt"
                 "INCLUDEPATH+=${python}/include/python2.7"
                 "INSTALL_DIR=$(out)"
                 "SHARE_DIR=$(out)/share"
                 ];

  installPhase = ''
    mkdir -p $out
    cp -r bin $out
    make install
  '';

  meta = with stdenv.lib; {
    description = "CsoundQt is a frontend for Csound with editor, integrated help, widgets and other features.";
    homepage = https://csoundqt.github.io/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hlolli ];
  };
}
