{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  icu,
  libkqueue,
  libuuid,
  tzdata,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "opencflite";
  version = "635.21.8";

  src = fetchFromGitHub {
    owner = "gerickson";
    repo = "opencflite";
    rev = "opencflite-${version}";
    hash = "sha256-ijyj4SFYQ0wZAFM2ehNnR9+yu5yDTSVW3VBycBT9l+A=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    icu
    libkqueue
    libuuid
    tzdata
    zlib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Cross platform port of the macOS CoreFoundation";
    homepage = "https://github.com/gerickson/opencflite";
    license = lib.licenses.apple-psl20;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = [ "x86_64-linux" ];
  };
}
