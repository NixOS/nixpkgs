{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  makeDesktopItem,
  makeWrapper,
  copyDesktopItems,
  alsa-lib,
  at-spi2-core,
  gtk3,
  libGL,
  libappindicator,
  libdrm,
  libgbm,
  libnotify,
  libxcb,
  nss,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "foxglove-studio";
  version = "2.37.0";

  src = fetchurl {
    url = "https://get.foxglove.dev/desktop/v${finalAttrs.version}/foxglove-studio-${finalAttrs.version}-linux-amd64.deb";
    hash = "sha256-XY+RclsP8uQS5aKe1FopdItAjbQ9uWQ8uVD9pb9n42U=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-core
    gtk3
    libGL
    libappindicator
    libdrm
    libgbm
    libnotify
    libxcb
    nss
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,opt,share}

    cp -r opt/Foxglove $out/opt/
    cp -r usr/share/icons $out/share/
    cp -r usr/share/mime $out/share/

    ln -s "$out/opt/Foxglove/foxglove-studio" $out/bin/foxglove-studio

    runHook postInstall
  '';

  preFixup = ''patchelf --add-needed libGL.so.1 --add-needed libEGL.so.1 $out/opt/Foxglove/foxglove-studio'';

  passthru.updateScript = ./update.sh;

  desktopItems = [
    (makeDesktopItem {
      name = "foxglove-studio";
      desktopName = "Foxglove Studio";
      comment = "Integrated robotics visualization and debugging";
      exec = "foxglove-studio %U";
      icon = "foxglove-studio";
      categories = [ "Development" ];
      mimeTypes = [
        "application/octet-stream"
        "application/zip"
        "x-scheme-handler/foxglove"
      ];
    })
  ];

  meta = {
    changelog = "https://docs.foxglove.dev/changelog/foxglove/v${finalAttrs.version}";
    description = "Visualization and observability platform for robotics";
    downloadPage = "https://foxglove.dev/download";
    homepage = "https://foxglove.dev/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ sascha8a ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
