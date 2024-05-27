{
  lib,
  SDL2,
  SDL2_mixer,
  callPackage,
  cmake,
  pkg-config,
  ninja,
  fetchFromGitHub,
  fetchpatch,
  libpng,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nxengine-evo";
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "nxengine";
    repo = "nxengine-evo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-krK2b1E5JUMxRoEWmb3HZMNSIHfUUGXSpyb4/Zdp+5A=";
  };

  patches = [
    # Fix building by adding SDL_MIXER to include path
    (fetchpatch {
      url = "https://github.com/nxengine/nxengine-evo/commit/1890127ec4b4b5f8d6cb0fb30a41868e95659840.patch";
      hash = "sha256-wlsIdN2RugOo94V3qj/AzYgrs2kf0i1Iw5zNOP8WQqI=";
    })
    # Fix buffer overflow
    (fetchpatch {
      url = "https://github.com/nxengine/nxengine-evo/commit/75b8b8e3b067fd354baa903332f2a3254d1cc017.patch";
      hash = "sha256-fZVaZAOHgFoNakOR2MfsvRJjuLhbx+5id/bcN8w/WWo=";
    })
    # Add missing include
    (fetchpatch {
      url = "https://github.com/nxengine/nxengine-evo/commit/0076ebb11bcfec5dc5e2e923a50425f1a33a4133.patch";
      hash = "sha256-8j3fFFw8DMljV7aAFXE+eA+vkbz1HdFTMAJmk3BRU04=";
    })
  ];

  nativeBuildInputs = [
    SDL2
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_mixer
    libpng
  ];

  strictDeps = true;

  # Allow finding game assets.
  postPatch = ''
    sed -i -e "s,/usr/share/,$out/share/," src/ResourceManager.cpp
  '';

  installPhase = ''
    runHook preInstall

    cd ..
    mkdir -p $out/bin/ $out/share/nxengine/
    install bin/* $out/bin/
  '' + ''
    cp -r ${finalAttrs.finalPackage.assets}/share/nxengine/data $out/share/nxengine/data
    chmod -R a=r,a+X $out/share/nxengine/data
  '' + ''
    runHook postInstall
  '';

  passthru = {
    assets = callPackage ./assets.nix { };
  };

  meta = {
    homepage = "https://github.com/nxengine/nxengine-evo";
    description = "A complete open-source clone/rewrite of the masterpiece jump-and-run platformer Doukutsu Monogatari (also known as Cave Story)";
    license = with lib.licenses; [
      gpl3Plus
    ];
    mainProgram = "nx";
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
