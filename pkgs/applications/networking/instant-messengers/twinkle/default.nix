{ lib
, fetchFromGitHub
, cmake
, libxml2
, libsndfile
, file
, readline
, bison
, flex
, ucommon
, ccrtp
, qtbase
, qttools
, qtquickcontrols2
, alsa-lib
, speex
, ilbc
, mkDerivation
, bcg729
}:

mkDerivation rec {
  pname = "twinkle";
  version = "unstable-2021-02-06";

  src = fetchFromGitHub {
    owner = "LubosD";
    repo = "twinkle";
    rev = "2301b66a3f54b266675415d261985488d86e9e4c";
    sha256 = "xSwcaj1Hm62iL7C/AxqjVR07VEae8gDgYdr2EWmCoOM=";
  };

  buildInputs = [
    libxml2
    file # libmagic
    libsndfile
    readline
    ucommon
    ccrtp
    qtbase
    qttools
    qtquickcontrols2
    alsa-lib
    speex
    ilbc
  ];

  nativeBuildInputs = [
    cmake
    bison
    flex
    bcg729
  ];

  cmakeFlags = [
    "-DWITH_G729=On"
    "-DWITH_SPEEX=On"
    "-DWITH_ILBC=On"
    /* "-DWITH_DIAMONDCARD=On" seems ancient and broken */
  ];

  meta = with lib; {
    changelog = "https://github.com/LubosD/twinkle/blob/${version}/NEWS";
    description = "A SIP-based VoIP client";
    homepage = "http://twinkle.dolezel.info/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.mkg20001 ];
    platforms = platforms.linux;
  };
}
