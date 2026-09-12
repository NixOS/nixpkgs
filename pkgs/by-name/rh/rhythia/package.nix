{
  alsa-lib,
  autoPatchelfHook,
  buildDotnetModule,
  copyDesktopItems,
  dbus,
  dotnetCorePackages,
  fetchFromGitHub,
  fontconfig,
  godotPackages_4_6,
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

  godotPackages = godotPackages_4_6;

  godot = godotPackages.godot-mono;

  export-templates = godot.export-templates-bin;

  dotnet-sdk = dotnetCorePackages.sdk_10_0;
  dotnet-runtime = dotnetCorePackages.runtime_10_0;

  runtimeDirs = {
    "x86_64-linux" = "linux-x64";
    "aarch64-linux" = "linux-arm";
  };
  runtimeDir =
    runtimeDirs.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

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
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Rhythia";
    repo = "Client";
    rev = finalAttrs.version;
    hash = "sha256-alwbuNJ+wa3VF0g8kYSebtuyc2Ouder5asNi9e62dvA=";
    fetchLFS = true;
  };

  __structuredAttrs = true;
  strictDeps = true;

  patches = [
    ./godot-dotnet-sdk-4.6.3.patch
  ];

  nugetDeps = ./deps.json;

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
    godot4.6-mono --headless --export-release "${preset}" ./build/Rhythia

    mkdir -p ./build/${dataDir}
    dotnet build ./Rhythia.csproj -o ./build/${dataDir}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 755 -t $out/libexec ./build/Rhythia
    ${lib.optionalString (
      # no libs there on arm
      # probably related to this https://github.com/Rhythia/Client/issues/145
      stdenv.hostPlatform.system == "x86_64-linux"
    ) "install -Dm 755 -t $out/libexec ./build/lib*"}

    install -Dm 755 -t $out/libexec/${dataDir} ./build/${dataDir}/*.dll
    install -Dm 755 -t $out/libexec/${dataDir} ./build/${dataDir}/runtimes/${runtimeDir}/native/*.so
    install -Dm 755 -t $out/libexec/${dataDir} ${dotnet-runtime}/share/dotnet/shared/Microsoft.NETCore.App/10.0.11/*

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
