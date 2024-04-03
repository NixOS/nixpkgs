{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  writeShellScriptBin,
  cmake,
  ninja,
  pkg-config,
  makeWrapper,
  zlib,
  libpng,
  SDL2,
  SDL2_net,
  hidapi,
  qt6,
  vulkan-loader,
}:

let
  cheats-json = fetchurl {
    url = "https://raw.githubusercontent.com/simple64/cheat-parser/87963b7aca06e0d4632b66bc5ffe7d6b34060f4f/cheats.json";
    hash = "sha256-rS/4Mdi+18C2ywtM5nW2XaJkC1YnKZPc4YdQ3mCfESU=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "simple64";
  version = "2024.09.1";

  src = fetchFromGitHub {
    owner = "simple64";
    repo = "simple64";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-t3V7mvHlCP8cOvizR3N9DiCofnSvSHI6U0iXXkaMb34=";
  };

  patches = [
    ./dont-use-vosk-and-discord.patch
    ./add-official-server-error-message.patch
  ];

  postPatch = ''
    cp ${cheats-json} cheats.json
  '';

  stictDeps = true;

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
    ninja
    pkg-config
    makeWrapper
    # fake git command for version info generator
    (writeShellScriptBin "git" "echo ${finalAttrs.src.rev}")
  ];

  buildInputs = [
    zlib
    libpng
    SDL2
    SDL2_net
    hidapi
    qt6.qtbase
    qt6.qtwebsockets
  ];

  dontUseCmakeConfigure = true;

  dontWrapQtApps = true;

  buildPhase = ''
    runHook preInstall

    sh build.sh

    runHook postInstall
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/simple64 $out/bin
    cp -r simple64/* $out/share/simple64

    makeWrapper $out/share/simple64/simple64-gui $out/bin/simple64-gui \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]} \
        "''${qtWrapperArgs[@]}"

    runHook postInstall
  '';

  meta = {
    description = "Easy to use N64 emulator";
    homepage = "https://simple64.github.io";
    license = lib.licenses.gpl3Only;
    mainProgram = "simple64-gui";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
