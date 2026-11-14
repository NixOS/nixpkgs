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
  perSystem =
    {
      "aarch64-linux" = {
        exportPreset = "Linux AArch64";
        dataDir = "data_Rhythia_linuxbsd_arm64";
      };
      "x86_64-linux" = {
        exportPreset = "Linux x86_64";
        dataDir = "data_Rhythia_linuxbsd_x86_64";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  inherit (perSystem) exportPreset dataDir;

  godot = godotPackages_4_7.godot-mono.override {
    useDotnetFromEnv = true;
  };
in

buildDotnetModule (finalAttrs: {
  pname = "rhythia";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "Rhythia";
    repo = "Client";
    rev = finalAttrs.version;
    hash = "sha256-09dGEC9w3MHHvGzQAlQbI9Cg8ywNsZ5k8rBcHvDbnDg=";
    fetchLFS = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    ./add-aarch64-linux-export-preset.patch
    ./enable-s3tc-bptc-image-compression.patch
  ];

  postPatch = ''
    rm dotnet-tools.json
  '';

  nugetDeps = ./deps.json;

  dotnet-sdk = dotnetCorePackages.sdk_10_0-source;

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
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
    mkdir -p "$HOME"/.local/share/godot/
    ln -s "${godot.export-templates-bin}"/share/godot/export_templates "$HOME"/.local/share/godot/

    mkdir -p ./build
    godot4.7-mono --headless --export-release "${exportPreset}" ./build/Rhythia

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
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      karol-broda
      poz
    ];
    mainProgram = "Rhythia";
  };
})
