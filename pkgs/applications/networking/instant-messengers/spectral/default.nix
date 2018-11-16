{ stdenv, fetchgit
, pkgconfig
, qmake, qtbase, qtquickcontrols2, qtmultimedia
, libpulseaudio
# Not mentioned but seems needed
, qtgraphicaleffects
# Unsure but needed by similar
, qtdeclarative, qtsvg
}:

stdenv.mkDerivation rec {
  name = "spectral-${version}";
  version = "2018-09-24";

  src = fetchgit {
    url = "https://gitlab.com/b0/spectral.git";
    rev = "c9d1d6887722860a52b597a0f74d0ce39c8622e1";
    sha256 = "1ym8jlqls4lcq5rd81vxw1dni79fc6ph00ip8nsydl6i16fngl4c";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ qtbase qtquickcontrols2 qtmultimedia qtgraphicaleffects qtdeclarative qtsvg ]
    ++ stdenv.lib.optional stdenv.hostPlatform.isLinux libpulseaudio;

  meta = with stdenv.lib; {
    description = "A glossy client for Matrix, written in QtQuick Controls 2 and C++";
    homepage = https://gitlab.com/b0/spectral;
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = with maintainers; [ dtzWill ];
  };
}
