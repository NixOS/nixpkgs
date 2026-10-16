{
  alsa-lib,
  autoPatchelfHook,
  buildDotnetModule,
  copyDesktopItems,
  darwin,
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
      "aarch64-darwin" = {
        exportPreset = "macOS";
        dataDir = "data_Rhythia_macos_arm64";
      };
    }
    .${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  inherit (perSystem) exportPreset dataDir;

  godot = godotPackages_4_7.godot-mono.override {
    useDotnetFromEnv = true;
  };

  exportPresetDir =
    if stdenv.hostPlatform.isLinux then
      ".local/share/godot/"
    else if stdenv.hostPlatform.isDarwin then
      "Library/Application Support/Godot/"
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";
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
    # TODO: remove both when new version is released
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  runtimeDependencies = [
    dbus
    fontconfig
    libGL
    pulseaudio
    vulkan-loader
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    libx11
    libxcursor
    libxext
    libxi
    libxinerama
    libxkbcommon
    libxrandr
    libxrender
    udev
    wayland
  ];

  buildPhase = ''
    runHook preBuild

    export HOME=$(mktemp -d)
    mkdir -p "$HOME/${exportPresetDir}"
    ln -s "${godot.export-templates-bin}/share/godot/export_templates" "$HOME/${exportPresetDir}"

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

  meta = {
    homepage = "https://wiki.rhythia.net/";
    description = "Aim-based rhythm game client built in Godot 4";
    license = lib.licenses.agpl3Only;
    # TODO: currently code signing on macos is broken
    # add lib.platforms.darwin when that's fixed
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      karol-broda
      poz
    ];
    mainProgram = "Rhythia";
  };
})
