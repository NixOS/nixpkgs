{
  stdenvNoCC,
  lib,
  fetchzip,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  gtk3,
  xdg-user-dirs,
  keybinder3,
  libnotify,
  gst_all_1,
  libva,
  libvdpau,
  lcms2,
  libarchive,
  alsa-lib,
  libpulseaudio,
  libgbm,
  libxscrnsaver,
  libxv,
}:

let
  dist =
    rec {
      x86_64-linux = {
        urlSuffix = "linux-x86_64.tar.gz";
        hash = "sha256-6akFImNU5EQLW6f2dQRUXUC8srM32xyVI14pjVxV6Sw=";
      };
      x86_64-darwin = {
        urlSuffix = "macos-universal.zip";
        hash = "sha256-sJ4mXSYsJICXMpDZemqRF3uYgB9SWNdbzcT1s2gHpZA=";
      };
      aarch64-darwin = x86_64-darwin;
    }
    ."${stdenvNoCC.hostPlatform.system}"
      or (throw "appflowy: No source for system: ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "appflowy";
  version = "0.11.8";

  src = fetchzip {
    url = "https://github.com/AppFlowy-IO/appflowy/releases/download/${finalAttrs.version}/AppFlowy-${finalAttrs.version}-${dist.urlSuffix}";
    inherit (dist) hash;
    stripRoot = false;
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ]
  ++ lib.optionals stdenvNoCC.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    gtk3
    keybinder3
    libnotify
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libva
    libvdpau
    lcms2
    libarchive
    alsa-lib
    libpulseaudio
    libgbm
    libxscrnsaver
    libxv
  ];

  dontBuild = true;
  dontConfigure = true;

  installPhase =
    lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      runHook preInstall

      cd AppFlowy/

      mkdir -p $out/{bin,opt}

      # Copy archive contents to the outpout directory
      cp -r ./* $out/opt/

      # Copy icon
      install -Dm444 data/flutter_assets/assets/images/flowy_logo.svg $out/share/icons/hicolor/scalable/apps/appflowy.svg

      runHook postInstall
    ''
    + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
      runHook preInstall

      mkdir -p $out/{Applications,bin}
      cp -r ./AppFlowy.app $out/Applications/

      runHook postInstall
    '';

  preFixup =
    lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
      # Add missing libraries to appflowy using the ones it comes with
      makeWrapper $out/opt/AppFlowy $out/bin/appflowy \
        --set LD_LIBRARY_PATH "$out/opt/lib/" \
        --prefix PATH : "${lib.makeBinPath [ xdg-user-dirs ]}"
    ''
    + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
      makeWrapper $out/Applications/AppFlowy.app/Contents/MacOS/AppFlowy $out/bin/appflowy
    '';

  desktopItems = lib.optionals stdenvNoCC.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "appflowy";
      desktopName = "AppFlowy";
      comment = finalAttrs.meta.description;
      exec = "appflowy %U";
      icon = "appflowy";
      categories = [ "Office" ];
      mimeTypes = [ "x-scheme-handler/appflowy-flutter" ];
    })
  ];

  meta = {
    description = "Open-source alternative to Notion";
    homepage = "https://www.appflowy.io/";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.agpl3Only;
    changelog = "https://github.com/AppFlowy-IO/appflowy/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ darkonion0 ];
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    mainProgram = "appflowy";
  };
})
