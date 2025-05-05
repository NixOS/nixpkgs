{
  lib,
  fetchFromGitHub,
  callPackage,
  stdenv,
  cmake,
  SDL2,
  SDL2_net,
  libogg,
  libvorbis,
  ffmpeg,
  zlib,
}:

let
  clunk = callPackage ./clunk.nix { };
in
stdenv.mkDerivation {
  pname = "vangers";
  version = "2.0-unstable-2024-09-30";

  src = fetchFromGitHub {
    owner = "KranX";
    repo = "Vangers";
    rev = "72145feed605856c6711bbbcb4f9db99db3434fd";
    hash = "sha256-IhCQh60wBzaRsj72Y8NUHrv9lvss0fmgHjzrO/subOI=";
  };

  buildInputs = [
    SDL2
    SDL2_net
    libogg
    libvorbis
    ffmpeg
    clunk
    zlib
  ];
  nativeBuildInputs = [ cmake ];

  installPhase = ''
    mkdir -p $out/bin
    install -T -m755 server/vangers_server $out/bin/vangers_server
    install -T -m755 src/vangers $out/bin/vangers
    install -T -m755 surmap/surmap $out/bin/surmap
  '';

  meta = {
    description = "The video game that combines elements of the racing and role-playing genres";
    homepage = "https://github.com/KranX/Vangers";
    mainProgram = "vangers";
    platforms = lib.platforms.all;
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ _3JlOy-PYCCKUi ];
  };
}
