{
  lib,
  stdenv,
  fetchurl,
  cmake,
  alsa-lib,
  fltk,
  pkg-config,
  makeWrapper,
  libdwarf,
  SDL,
  SDL_mixer,
  SDL_net,
  wxGTK32,
  zstd,
}:

stdenv.mkDerivation rec {
  pname = "odamex";
  version = "11.1.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-src-${version}.tar.gz";
    sha256 = "sha256-DEM0JcA4u4s5OqkPNNcLIf2nLV+M/KHCVI/pSFEfYWA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    fltk
    libdwarf
    SDL
    SDL_mixer
    SDL_net
    wxGTK32
    zstd
  ];

  cmakeFlags = [
    "-DUSE_EXTERNAL_LIBDWARF=ON"
  ];

  postPatch = ''
    substituteInPlace libraries/cpptrace-lib.cmake \
      --replace '"-DCPPTRACE_USE_EXTERNAL_LIBDWARF=''${USE_EXTERNAL_LIBDWARF}"' '"-DCPPTRACE_USE_EXTERNAL_LIBDWARF=''${USE_EXTERNAL_LIBDWARF}" "-DCPPTRACE_FIND_LIBDWARF_WITH_PKGCONFIG=ON"'
  '';

  installPhase = ''
    runHook preInstall
  ''
  + (
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/{Applications,bin}
        mv odalaunch/odalaunch.app $out/Applications
        makeWrapper $out/{Applications/odalaunch.app/Contents/MacOS,bin}/odalaunch
      ''
    else
      ''
        make install
      ''
  )
  + ''
    runHook postInstall
  '';

  meta = {
    homepage = "http://odamex.net/";
    description = "Client/server port for playing old-school Doom online";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
