{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  alsa-lib,
  fontconfig,
  freetype,
  glib,
  gtk3,
  libGL,
  libx11,
  libxi,
  libxrender,
  libxtst,
  libxkbcommon,
  wayland,
  zlib,
  undmg,
  unzip,
}:

let
  pname = "foldersync-desktop";
  version = "2.8.5";

  sources = {
    x86_64-linux = {
      arch = "linux-amd64";
      hash = "sha256-HCmdGA1gK5ZuyEGMsJ2NIgIFERZMmbk4wA9pUK4QP7g=";
    };
    aarch64-linux = {
      arch = "linux-aarch64";
      hash = "sha256-w+E9DQSvioh7JjfZKzwBK3OexAijAeZVrbN0hiAOEOE=";
    };
    x86_64-darwin = {
      arch = "mac-amd64";
      hash = "sha256-VIjFFkfB1sknMJcio5OTCuqyys6P9reIrB72lFnRrDg=";
    };
    aarch64-darwin = {
      arch = "mac-aarch64";
      hash = "sha256-140xkPV+N/DPxFTZit0xO1IVgykQQToHSmy1noXzwyM=";
    };
  };
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version;

  src =
    let
      inherit
        (sources.${stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${stdenv.hostPlatform.system}")
        )
        arch
        hash
        ;
      ext = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";
    in
    fetchurl {
      url = "https://github.com/tacitdynamics/foldersync-desktop-production/releases/download/${finalAttrs.version}/foldersync-desktop-${finalAttrs.version}-${arch}.${ext}";
      inherit hash;
    };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    undmg
    unzip
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    fontconfig
    freetype
    glib
    gtk3
    libGL
    libx11
    libxi
    libxrender
    libxtst
    libxkbcommon
    wayland
    zlib
    stdenv.cc.cc.lib
  ];

  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [
    fontconfig
    freetype
    glib
    libx11
    libxrender
    libxtst
    libxkbcommon
    wayland
  ];

  sourceRoot =
    if stdenv.hostPlatform.isDarwin then "." else "foldersync-desktop-${finalAttrs.version}";

  dontBuild = true;
  dontConfigure = true;

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "foldersync-desktop";
      desktopName = "FolderSync Desktop";
      comment = "File syncing and backup application";
      exec = "foldersync-desktop %U";
      icon = "foldersync-desktop";
      terminal = false;
      mimeTypes = [ "x-scheme-handler/foldersync-desktop" ];
      categories = [
        "Utility"
        "FileTools"
        "Filesystem"
        "System"
      ];
      startupWMClass = "dk-tacit-desktop-foldersync-MainKt";
    })
  ];

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p "$out/Applications" "$out/bin"
        cp -r *.app "$out/Applications/" || cp -r "FolderSync Desktop.app" "$out/Applications/"

        appPath=$(find "$out/Applications" -name "*.app" -maxdepth 1 | head -1)
        if [ -n "$appPath" ]; then
          makeWrapper "$appPath/Contents/MacOS/"* "$out/bin/foldersync-desktop" || true
        fi

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/{bin,lib/foldersync-desktop,share}
        cp -r lib $out/lib/foldersync-desktop/
        cp -r bin $out/lib/foldersync-desktop/
        cp -r share/icons $out/share/

        for size in 16x16 32x32 44x44 64x64 128x128 150x150 256x256 512x512 1024x1024; do
          if [ -d "$out/share/icons/hicolor/$size/apps" ]; then
            for icon in $out/share/icons/hicolor/$size/apps/*; do
              mv "$icon" "$out/share/icons/hicolor/$size/apps/foldersync-desktop.png"
            done
          fi
        done

        makeWrapper $out/lib/foldersync-desktop/bin/foldersync-desktop $out/bin/foldersync-desktop \
          --set LD_LIBRARY_PATH "${
            lib.makeLibraryPath [
              alsa-lib
              fontconfig
              freetype
              glib
              gtk3
              libGL
              libx11
              libxi
              libxrender
              libxtst
              libxkbcommon
              wayland
            ]
          }"

        runHook postInstall
      '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "File syncing and backup application for desktop";
    longDescription = ''
      FolderSync is a file synchronization and backup application that supports
      syncing folders between your computer and various cloud storage providers.
      It features automatic file synchronization, support for 20+ cloud storage
      providers, secure file transfer with encryption, flexible scheduling options,
      two-way and one-way synchronization, and detailed sync logs.
    '';
    homepage = "https://foldersync.io/";
    downloadPage = "https://github.com/tacitdynamics/foldersync-desktop-production/releases";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ LouisJalouzot ];
    mainProgram = "foldersync-desktop";
    platforms = lib.attrNames sources;
  };
})
