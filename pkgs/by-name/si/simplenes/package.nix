{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  sfml_2,
}:

stdenv.mkDerivation {
  pname = "simplenes";
  version = "0-unstable-2025-01-05";

  src = fetchFromGitHub {
    owner = "amhndu";
    repo = "SimpleNES";
    rev = "154a2fd4f2f2611a27197aa8d802bbcdfd1a0ea3";
    hash = "sha256-4Nb42tb/pJaVOOhj7hH9cQLDKCz8GUXWz8KAHPOd9nE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ sfml_2 ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp ./SimpleNES $out/bin

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/amhndu/SimpleNES";
    description = "NES emulator written in C++";
    license = lib.licenses.gpl3;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "SimpleNES";
  };
}
