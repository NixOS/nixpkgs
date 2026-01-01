{
  clangStdenv,
  fetchFromGitHub,
  fpc,
  lazarus-qt6,
  lib,
  libx11,
  makeWrapper,
  nix-update-script,
  qt6Packages,
  SDL2,
  vulkan-loader,
  zlib,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "pascube";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "benjamimgois";
    repo = "pascube";
    tag = finalAttrs.version;
    hash = "sha256-qKjOA5/l2trQC238WheeOzqbpltjkwksqzMtcfw7ci0=";
  };

  nativeBuildInputs = [
    fpc
    lazarus-qt6
    makeWrapper
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.libqtpas
    qt6Packages.qtbase
    SDL2
  ];

  buildPhase =
    let
      clangBuild =
        if clangStdenv.hostPlatform.system == "i386-linux" then
          "clang -c -g -gdwarf-2 -masm=intel -Wno-c++2b-extensions -Wno-return-type -Wno-deprecated -O4 -march=haswell -D linux -fverbose-asm -fno-builtin pasvulkan/src/lzma_c/LzmaDec.c -o pasvulkan/src/lzma_c/lzmadec_linux_x86_32.o"
        else if clangStdenv.hostPlatform.system == "x86_64-linux" then
          "clang -c -g -gdwarf-2 -masm=intel -Wno-c++2b-extensions -Wno-return-type -Wno-deprecated -O4 -march=haswell -D linux -fverbose-asm -fno-builtin pasvulkan/src/lzma_c/LzmaDec.c -o pasvulkan/src/lzma_c/lzmadec_linux_x86_64.o"
        else if clangStdenv.hostPlatform.system == "aarch64-linux" then
          "clang -c -g -gdwarf-2 -Wno-c++2b-extensions -Wno-return-type -Wno-deprecated -O4 -D linux -fverbose-asm -fno-builtin pasvulkan/src/lzma_c/LzmaDec.c -o pasvulkan/src/lzma_c/lzmadec_linux_aarch64.o"
        else if clangStdenv.hostPlatform.system == "armv7-linux" then
          "clang -c -mfloat-abi=hard -g -gdwarf-2 -Wno-c++2b-extensions -Wno-return-type -Wno-deprecated -O4 -D linux -fverbose-asm -fno-builtin pasvulkan/src/lzma_c/LzmaDec.c -o pasvulkan/src/lzma_c/lzmadec_linux_arm7.o"
        else
          throw "Unsupported platform: ${clangStdenv.hostPlatform.system}";
    in
    ''
      runHook preBuild
      ${clangBuild}
      HOME=$(mktemp -d) lazbuild \
        --lazarusdir=${lazarus-qt6}/share/lazarus \
        --widgetset=qt6 \
        pascube.lpi
      runHook postBuild
    '';

  installPhase = ''
    runHook preInstall
    install -Dm755 pascube $out/bin/pascube
    mkdir -p $out/share/pascube
    cp -a assets $out/share/pascube
    install -Dm644 data/pascube.desktop $out/share/applications/pascube.desktop
    for sz in 128x128 256x256 512x512; do
      install -Dm644 "data/icons/''${sz}/pascube.png" \
        "$out/share/icons/hicolor/''${sz}/apps/pascube.png"
    done
    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup
    wrapProgram $out/bin/pascube --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        libx11
        SDL2
        vulkan-loader
        zlib
      ]
    }
    runHook postFixup
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple OpenGL spinning cube written in Pascal";
    homepage = "https://github.com/benjamimgois/pascube";
    changelog = "https://github.com/benjamimgois/pascube/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "pascube";
    platforms = lib.platforms.linux;
  };
})
