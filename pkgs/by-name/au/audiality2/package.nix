{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  # The two audio backends:
  SDL2,
  jack2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "audiality2";
  version = "1.9.4";

  src = fetchFromGitHub {
    owner = "olofson";
    repo = "audiality2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QNjA5dmAXFl9GxxE7+T43ad42IL8vUQdqLjXpI6y+EY=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      'cmake_minimum_required(VERSION 2.8)' \
      'cmake_minimum_required(VERSION 3.5)'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    jack2
  ];

  meta = {
    description = "Realtime scripted modular audio engine for video games and musical applications";
    mainProgram = "a2play";
    homepage = "https://olofson.github.io/audiality2/";
    license = lib.licenses.zlib;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ fgaz ];
  };
})
