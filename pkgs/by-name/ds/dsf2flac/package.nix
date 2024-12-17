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

stdenv.mkDerivation rec {
  pname = "dsf2flac";
  version = "unstable-2021-07-31";

  src = fetchFromGitHub {
    owner = "hank";
    repo = pname;
    rev = "6b109cd276ec7c7901f96455c77cf2d2ebfbb181";
    sha256 = "sha256-VlXfywgYhI2QuGQvpD33BspTTgT0jOKUV3gENq4HiBU=";
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
    export LIBS="$LIBS -lz"
  '';

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ];

  meta = with lib; {
    description = "DSD to FLAC transcoding tool";
    homepage = "https://github.com/hank/dsf2flac";
    license = licenses.gpl2;
    maintainers = with maintainers; [ artemist ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "dsf2flac";
  };
}
