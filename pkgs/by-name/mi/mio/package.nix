{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mio";
  version = "unstable-2023-03-03";

  src = fetchFromGitHub {
    owner = "vimpunk";
    repo = "mio";
    rev = "8b6b7d878c89e81614d05edca7936de41ccdd2da";
    hash = "sha256-j/wbjyI2v/BsFz2RKi8ZxMKuT+7o5uI4I4yIkUran7I=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Cross-platform C++11 header-only library for memory mapped file IO";
    homepage = "https://github.com/vimpunk/mio";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.szanko ];
    platforms = lib.platforms.all;
  };
})
