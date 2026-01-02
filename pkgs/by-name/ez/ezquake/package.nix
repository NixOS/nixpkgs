{
  lib,
  stdenv,
  fetchFromGitHub,
  curl,
  expat,
  jansson,
  libpng,
  libjpeg,
  libGL,
  libX11,
  libsndfile,
  pcre2,
  minizip,
  cmake,
  pkg-config,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "ezquake";
  version = "3.6.8";

  src = fetchFromGitHub {
    owner = "QW-Group";
    repo = "ezquake" + "-source";
    tag = version;
    fetchSubmodules = true;
    hash = "sha256-BIkBl6ncwo0NljuqOHJ3yQeDTcClh5FGssdFsKUjN90=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    minizip
    pcre2
    expat
    curl
    jansson
    libpng
    libjpeg
    libGL
    libsndfile
    libX11
    SDL2
  ];

  installPhase =
    let
      sys = lib.last (lib.splitString "-" stdenv.hostPlatform.system);
      arch = lib.head (lib.splitString "-" stdenv.hostPlatform.system);
    in
    ''
      mkdir -p $out/bin
      find .
      mv ezquake-${sys}-${arch} $out/bin/ezquake
    '';

  enableParallelBuilding = true;

  meta = {
    homepage = "https://ezquake.com/";
    description = "Modern QuakeWorld client focused on competitive online play";
    mainProgram = "ezquake";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ edwtjo ];
  };
}
