{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  boost,
  flac,
  id3lib,
  pkg-config,
  taglib,
  zlib,
}:

stdenv.mkDerivation {
  pname = "dsf2flac";
  version = "0-unstable-2025-01-31";

  src = fetchFromGitHub {
    owner = "hank";
    repo = "dsf2flac";
    rev = "39d43901ce27d0cc53b5a4eb277a65082e9906f0";
    hash = "sha256-I8BupNE49+9oExR/GhoZUVbCHhDJEz3hhvQnbi8ZVGs=";
  };

  buildInputs = [
    boost
    flac
    id3lib
    taglib
    zlib
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    export LIBS="$LIBS -lz -lboost_timer"
  '';

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  meta = {
    description = "DSD to FLAC transcoding tool";
    homepage = "https://github.com/hank/dsf2flac";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ artemist ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "dsf2flac";
  };
}
