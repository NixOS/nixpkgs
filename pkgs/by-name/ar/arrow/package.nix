{
  stdenv,
  lib,
  fetchFromGitHub,
  godot_4_4,
  alsa-lib,
  libGL,
  libpulseaudio,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXrandr,
  udev,
  vulkan-loader,
  autoPatchelfHook,
  writableTmpDirAsHomeHook,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "arrow";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "mhgolkar";
    repo = "Arrow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+Tlqh0Xn2xnF2AWv9u5xIWo6Mvg/uEsqqxWx70kd3+k=";
  };

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "Arrow";
      exec = "Arrow";
      icon = "Arrow";
      terminal = false;
      comment = "Game Narrative Design Tool";
      desktopName = "Arrow";
      categories = [ "Application" ];
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    writableTmpDirAsHomeHook
    godot_4_4
    copyDesktopItems
  ];

  runtimeDependencies = map lib.getLib [
    alsa-lib
    libGL
    libpulseaudio
    libX11
    libXcursor
    libXext
    libXi
    libXrandr
    udev
    vulkan-loader
  ];

  passthru.updateScript = nix-update-script { };

  buildPhase = ''
    runHook preBuild

    ln -s "${godot_4_4.export-templates-bin}" $HOME/.local

    mkdir -p build
    godot4 --headless --export-release Linux ./build/Arrow

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D -m 755 -t $out/libexec ./build/Arrow
    install -D -m 644 -t $out/libexec ./build/Arrow.pck

    install -d -m 755 $out/bin
    ln -s $out/libexec/Arrow $out/bin/Arrow

    install -vD icon.svg $out/share/icons/hicolor/scalable/apps/Arrow.svg

    runHook postInstall
  '';

  meta = {
    homepage = "https://mhgolkar.github.io/Arrow/";
    description = "Game Narrative Design Tool";
    license = lib.licenses.mit;
    mainProgram = "Arrow";
    maintainers = with lib.maintainers; [ miampf ];
    platforms = lib.platforms.linux;
  };
})
