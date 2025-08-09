{
  lib,
  SDL2,
  alsa-lib,
  boost,
  callPackage,
  cmake,
  curl,
  freeimage,
  freetype,
  libGL,
  libGLU,
  libvlc,
  pkg-config,
  rapidjson,
  stdenv,
}:

let
  sources = callPackage ./sources.nix { };
in
stdenv.mkDerivation {
  inherit (sources.emulationstation) pname version src;

  postUnpack = ''
    pushd $sourceRoot/external/pugixml
    cp --verbose --archive ${sources.pugixml.src}/* .
    chmod --recursive 744 .
    popd
  '';

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

  cmakeFlags = [ (lib.cmakeBool "GL" true) ];

  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 ../emulationstation $out/bin/emulationstation
    mkdir -p $out/share/emulationstation/
    cp -r ../resources $out/share/emulationstation/

    runHook postInstall
  '';

  # es-core/src/resources/ResourceManager.cpp: resources are searched at the
  # same place of binaries.
  postFixup = ''
    pushd $out
    ln -s $out/share/emulationstation/resources $out/bin/
    popd
  '';

  passthru = {
    inherit sources;
  };

  meta = {
    homepage = "https://github.com/RetroPie/EmulationStation";
    description = "Flexible emulator front-end supporting keyboardless navigation and custom system themes (forked by RetroPie)";
    license = with lib.licenses; [ mit ];
    mainProgram = "emulationstation";
    maintainers = with lib.maintainers; [
      edwtjo
    ];
    platforms = lib.platforms.linux;
  };
}
