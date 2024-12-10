{
  lib,
  fetchFromGitHub,
  cmake,
  libxml2,
  libsndfile,
  file,
  readline,
  bison,
  flex,
  ucommon,
  ccrtp,
  qtbase,
  qttools,
  qtquickcontrols2,
  alsa-lib,
  speex,
  ilbc,
  mkDerivation,
  bcg729,
}:

mkDerivation rec {
  pname = "twinkle";
  version = "unstable-2023-03-25";

  src = fetchFromGitHub {
    owner = "LubosD";
    repo = "twinkle";
    rev = "355813d5640ad58c84dc063826069384470ce310";
    hash = "sha256-u+RewFwW17Oz2+lJLlmwebaGn4ebTBquox9Av7Jh1as=";
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
    "-DHAVE_LIBATOMIC=atomic"
    # "-DWITH_DIAMONDCARD=On" seems ancient and broken
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
