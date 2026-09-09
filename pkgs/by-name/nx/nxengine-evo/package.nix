{
  lib,
  SDL2,
  SDL2_mixer,
  SDL2_image,
  callPackage,
  cmake,
  pkg-config,
  ninja,
  fetchFromGitHub,
  fetchpatch,
  libpng,
  libjpeg,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nxengine-evo";
  version = "2.6.5-1";

  src = fetchFromGitHub {
    owner = "nxengine";
    repo = "nxengine-evo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-UufvtfottD9DrnjN9xhAlkNdW5Ha+vZwf/4uKDtF5ho=";
  };

  patches = [
    # Add missing include
    (fetchpatch {
      url = "https://github.com/nxengine/nxengine-evo/commit/0076ebb11bcfec5dc5e2e923a50425f1a33a4133.patch";
      hash = "sha256-8j3fFFw8DMljV7aAFXE+eA+vkbz1HdFTMAJmk3BRU04=";
    })
    # Update minimum CMake version to 3.10
    (fetchpatch {
      url = "https://github.com/nxengine/nxengine-evo/commit/7e228063441da50f65a78bf2213e85b7fceffae9.patch";
      hash = "sha256-Vi8nE7IdvQbMDrXycw9hLsuHQwbpu1eiUTLSaIcRoUQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    SDL2_image
    libpng
    libjpeg
  ];

  strictDeps = true;

  # Allow finding game assets.
  postPatch = ''
    sed -i -e "s,/usr/share/,$out/share/," src/ResourceManager.cpp
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin/ $out/share/nxengine/
    install nxengine-evo $out/bin/
  ''
  + ''
    cp -r ${finalAttrs.finalPackage.assets}/share/nxengine/data $out/share/nxengine/data
    chmod -R a=r,a+X $out/share/nxengine/data
  ''
  + ''
    runHook postInstall
  '';

  passthru = {
    assets = callPackage ./assets.nix { };
  };

  meta = {
    homepage = "https://github.com/nxengine/nxengine-evo";
    changelog = "https://github.com/nxengine/nxengine-evo/releases/tag/${finalAttrs.src.rev}";
    description = "Complete open-source clone/rewrite of the masterpiece jump-and-run platformer Doukutsu Monogatari (also known as Cave Story)";
    license = with lib.licenses; [
      gpl3Plus
    ];
    mainProgram = "nxengine-evo";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
