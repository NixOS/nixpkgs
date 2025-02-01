{ lib
, SDL2
, alsa-lib
, boost
, cmake
, curl
, fetchFromGitHub
, freeimage
, freetype
, libGL
, libGLU
, libvlc
, pkg-config
, rapidjson
, stdenv
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "emulationstation";
  version = "2.11.2";

  src = fetchFromGitHub {
    owner = "RetroPie";
    repo = "EmulationStation";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-J5h/578FVe4DXJx/AvpRnCIUpqBeFtmvFhUDYH5SErQ=";
  };

  nativeBuildInputs = [
    SDL2
    cmake
    pkg-config
  ];

  buildInputs = [
    SDL2
    alsa-lib
    boost
    curl
    freeimage
    freetype
    libGL
    libGLU
    libvlc
    rapidjson
  ];

  strictDeps = true;

  cmakeFlags = [
    (lib.cmakeBool "GL" true)
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 ../emulationstation $out/bin/emulationstation
    mkdir -p $out/share/emulationstation/
    cp -r ../resources $out/share/emulationstation/

    runHook preInstall
  '';

  # es-core/src/resources/ResourceManager.cpp: resources are searched at the
  # same place of binaries.
  postFixup = ''
    pushd $out
    ln -s $out/share/emulationstation/resources $out/bin/
    popd
  '';

  meta = {
    homepage = "https://github.com/RetroPie/EmulationStation";
    description = "A flexible emulator front-end supporting keyboardless navigation and custom system themes (forked by RetroPie)";
    license = with lib.licenses; [ mit ];
    mainProgram = "emulationstation";
    maintainers = with lib.maintainers; [ AndersonTorres edwtjo ];
    platforms = lib.platforms.linux;
  };
})
