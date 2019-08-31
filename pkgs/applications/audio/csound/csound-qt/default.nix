{ stdenv, csound, desktop-file-utils,
  fetchFromGitHub, python, python-qt, qmake,
  qtwebengine, qtxmlpatterns, rtmidi, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "csound-qt";
  version = "0.9.6-beta3";

  src = fetchFromGitHub {
    owner = "CsoundQt";
    repo = "CsoundQt";
    rev = "${version}";
    sha256 = "007jhkh0k6qk52r77i067999dwdiimazix6ggp2hvyc4pj6n5dip";
  };

  patches = [
    (fetchpatch {
      name = "examplepath.patch";
      url = "https://github.com/CsoundQt/CsoundQt/commit/09f2d515bff638cbcacb450979d66e273a59fdec.diff";
      sha256 = "0y23kf8m1mh9mklsvf908b2b8m2w2rji8qvws44paf1kpwnwdmgm";
    })
    ./rtmidipath.patch
  ];

  nativeBuildInputs = [ qmake qtwebengine qtxmlpatterns ];

  buildInputs = [ csound desktop-file-utils rtmidi ];

  qmakeFlags = [ "qcs.pro" "CONFIG+=rtmidi" "CONFIG+=pythonqt"
                 "CONFIG+=record_support" "CONFIG+=html_webengine"
                 "CSOUND_INCLUDE_DIR=${csound}/include/csound"
                 "CSOUND_LIBRARY_DIR=${csound}/lib"
                 "RTMIDI_DIR=${rtmidi.src}"
                 "PYTHONQT_SRC_DIR=${python-qt}/include/PythonQt"
                 "PYTHONQT_LIB_DIR=${python-qt}/lib"
                 "LIBS+=-L${python-qt}/lib"
                 "INCLUDEPATH+=${python-qt}/include/PythonQt"
                 "INCLUDEPATH+=${python}/include/python2.7"
                 "INSTALL_DIR=${placeholder "out"}"
                 "SHARE_DIR=${placeholder "out"}/share"
                 ];

  meta = with stdenv.lib; {
    description = "CsoundQt is a frontend for Csound with editor, integrated help, widgets and other features.";
    homepage = https://csoundqt.github.io/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ hlolli ];
  };
}
