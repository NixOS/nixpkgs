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
  version = "unstable-2024-20-11";

  src = fetchFromGitHub {
    owner = "LubosD";
    repo = "twinkle";
    rev = "e067dcba28f4e2acd7f71b875fc4168e9706aaaa";
    hash = "sha256-3YtZwP/ugWOSfUa4uaEAEEsk9i5j93eLt5lHgAu5qqI=";
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

  meta = {
    changelog = "https://github.com/LubosD/twinkle/blob/${version}/NEWS";
    description = "SIP-based VoIP client";
    homepage = "http://twinkle.dolezel.info/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.mkg20001 ];
    platforms = lib.platforms.linux;
  };
}
