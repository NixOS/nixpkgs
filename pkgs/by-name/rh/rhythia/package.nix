{
  alsa-lib,
  autoPatchelfHook,
  buildDotnetModule,
  copyDesktopItems,
  dbus,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig,
  godotPackages_4_7,
  lib,
  libGL,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxinerama,
  libxkbcommon,
  libxrandr,
  libxrender,
  makeDesktopItem,
  pulseaudio,
  stdenv,
  udev,
  vulkan-loader,
  wayland,
}:

let
  presets = {
    "x86_64-linux" = "Linux x86_64";
    "aarch64-linux" = "Linux AArch64";
  };
  preset =
    presets.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  # godotPackages = godotPackages_4_6;
  # indev branch
  godotPackages = godotPackages_4_7;

  godot = godotPackages.godot-mono.override {
    inherit dotnet-sdk;
    dotnet-sdk_alt = dotnet-sdk;
  };

  export-templates = godot.export-templates-bin;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  dataDirs = {
    "x86_64-linux" = "data_Rhythia_linuxbsd_x86_64";
    "aarch64-linux" = "data_Rhythia_linuxbsd_arm64";
  };
  dataDir =
    dataDirs.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in

buildDotnetModule (finalAttrs: {
  pname = "rhythia";
  # version = "0.1.2";
  # indev branch
  version = "0-unstable-2026-09-11";

  # src = fetchFromGitHub {
  #   owner = "Rhythia";
  #   repo = "Client";
  #   rev = finalAttrs.version;
  #   hash = "sha256-alwbuNJ+wa3VF0g8kYSebtuyc2Ouder5asNi9e62dvA=";
  #   fetchLFS = true;
  # };

  # indev branch
  src = fetchFromGitHub {
    owner = "Rhythia";
    repo = "Client";
    rev = "41874d670cf0a2a5309a8de052df2e84e411c079";
    hash = "sha256-7gK7shxbHL/GtP29i3+FV63Dtt1snlr2qQGktzkgNvM=";
    fetchLFS = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    # ./godot-dotnet-sdk-4.6.3.patch
    # indev branch
    ./godot-dotnet-sdk-4.7.2.patch
  ];

  nugetDeps = ./deps-indev.json;

  inherit dotnet-sdk dotnet-runtime;

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dotnet-sdk
    godot
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Rhythia";
      desktopName = "Rhythia";
      genericName = finalAttrs.meta.description;
      comment = finalAttrs.meta.description;
      icon = "Rhythia";
      exec = "Rhythia";
      categories = [ "Game" ];
      keywords = [
        "rhythm"
        "rhythia"
      ];
      singleMainWindow = true;
      terminal = false;
      prefersNonDefaultGPU = true;
    })
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir -p $HOME/.local/share/godot/
    ln -s "${export-templates}"/share/godot/export_templates "$HOME"/.local/share/godot/

    cp ${./export_presets.cfg} ./export_presets.cfg

    mkdir -p ./build
    godot4.7-mono --headless --export-release "${preset}" ./build/Rhythia

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 -t $out/libexec ./build/Rhythia
    install -Dm 755 -t $out/libexec/${dataDir} ./build/${dataDir}/*

    install -Dm 644 ./textures/icon.svg $out/share/icons/hicolor/scalable/apps/Rhythia.svg
    install -dm 755 $out/bin

    ln -s $out/libexec/Rhythia $out/bin/Rhythia
    ln -s $out/bin/Rhythia $out/bin/rhythia

    runHook postInstall
  '';

  postFixup = ''
    patchelf --add-rpath "$out/libexec:${
      lib.makeLibraryPath [
        alsa-lib
        dbus
        fontconfig
        libGL
        libx11
        libxcursor
        libxext
        libxi
        libxinerama
        libxkbcommon
        libxrandr
        libxrender
        pulseaudio
        udev
        vulkan-loader
        wayland
      ]
    }" $out/libexec/Rhythia
  '';

  meta = {
    homepage = "https://wiki.rhythia.net/";
    description = "Aim-based rhythm game client built in Godot 4";
    license = lib.licenses.agpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [ poz ];
    mainProgram = "Rhythia";
  };
})
