{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  makeWrapper,
  SDL2,
  SDL2_mixer,
  SDL2_net,
  wxGTK32,
  zlib,
  fltk,
  curl,
  cairo,
  pango,
  glfw,
  glm,
  alsa-lib,
  deutex,
  portmidi,
}:

stdenv.mkDerivation rec {
  pname = "odamex";
  version = "11.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-src-${version}.tar.gz";
    hash = "sha256-fk6DrAhUa3eOqeCNWjSoKg9X81Bb3jrUq6JloTwfE4c=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    deutex
  ];

  buildInputs = [
    glm
    glfw
    fltk
    zlib
    SDL2
    SDL2_mixer
    SDL2_net
    wxGTK32
    curl
    cairo
    pango
    alsa-lib
    portmidi
  ];

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
