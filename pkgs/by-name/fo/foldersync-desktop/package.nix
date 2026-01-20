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
  libX11,
  libXi,
  libXrender,
  libXtst,
  libxkbcommon,
  wayland,
  zlib,
  undmg,
  unzip,
}:

let
  pname = "foldersync-desktop";
  version = "2.8.3";

  sources = {
    x86_64-linux = {
      arch = "linux-amd64";
      hash = "sha256-6C+nnuNH+9Wc8Pqqn3EOQMoIe6Kp+TTIflIGYY1EYJ8=";
    };
    aarch64-linux = {
      arch = "linux-aarch64";
      hash = "sha256-BjggRsSSQGFAnlDbC7gYpU16obXT6aYuyfx4MnHRKlM=";
    };
    x86_64-darwin = {
      arch = "mac-amd64";
      hash = "sha256-rWZPjgLqbRjMzvigBoF8F2XYqRCNHKJUsCffnbEaEgs=";
    };
    aarch64-darwin = {
      arch = "mac-aarch64";
      hash = "sha256-uEopiDsJVKxws3nVdxEzR78AVuYqsHyKqAK669wronU=";
    };
  };

  src =
    let
      inherit (sources.${stdenv.hostPlatform.system}) arch hash;
      ext = if stdenv.hostPlatform.isDarwin then "zip" else "tar.gz";
    in
    fetchurl {
      url = "https://github.com/tacitdynamics/foldersync-desktop-production/releases/download/${version}/${pname}-${version}-${arch}.${ext}";
      inherit hash;
    };

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

  passthru.updateScript = ./update.sh;

  linux = stdenv.mkDerivation (finalAttrs: {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    sourceRoot = "${pname}-${finalAttrs.version}";

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
      copyDesktopItems
    ];

    buildInputs = [
      alsa-lib
      fontconfig
      freetype
      glib
      gtk3
      libGL
      libX11
      libXi
      libXrender
      libXtst
      libxkbcommon
      wayland
      zlib
      stdenv.cc.cc.lib
    ];

    runtimeDependencies = [
      fontconfig
      freetype
      glib
      libX11
      libXrender
      libXtst
      libxkbcommon
      wayland
    ];

    dontBuild = true;
    dontConfigure = true;

    desktopItems = [
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
        ];
        startupWMClass = "dk-tacit-desktop-foldersync-MainKt";
      })
    ];

    installPhase = ''
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
            libX11
            libXi
            libXrender
            libXtst
            libxkbcommon
            wayland
          ]
        }\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}"

      runHook postInstall
    '';
  });

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    nativeBuildInputs = [
      undmg
      unzip
      makeWrapper
    ];

    sourceRoot = ".";

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/Applications" "$out/bin"
      cp -r *.app "$out/Applications/" || cp -r "FolderSync Desktop.app" "$out/Applications/"

      appPath=$(find "$out/Applications" -name "*.app" -maxdepth 1 | head -1)
      if [ -n "$appPath" ]; then
        makeWrapper "$appPath/Contents/MacOS/"* "$out/bin/foldersync-desktop" || true
      fi

      runHook postInstall
    '';
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
