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
  version = "2.29.1";

  src = fetchurl {
    url = "https://get.foxglove.dev/desktop/v${finalAttrs.version}/foxglove-studio-${finalAttrs.version}-linux-amd64.deb";
    hash = "sha256-WkyHlCTqbXikhMqSl+vkUHDe3KW9ika+SbHbn9KT7tk=";
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
    libappindicator
    libdrm
    libgbm
    libnotify
    libxcb
    nss
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,opt,share}

    cp -r opt/Foxglove $out/opt/
    cp -r usr/share/icons $out/share/
    cp -r usr/share/mime $out/share/

    ln -s "$out/opt/Foxglove/foxglove-studio" $out/bin/foxglove-studio

    runHook postInstall
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/foxglove-studio --prefix LD_LIBRARY_PATH : ${libGL}/lib
  '';

  passthru.updateScript = ./update.sh;

  desktopItems = [
    (makeDesktopItem {
      name = "foxglove-studio";
      desktopName = "Foxglove Studio";
      comment = "Integrated robotics visualization and debugging.";
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
    description = "Foxglove is a visualization and observability platform for robotics.";
    downloadPage = "https://foxglove.dev/download";
    homepage = "https://foxglove.dev/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ sascha8a ];
    platforms = [ "x86_64-linux" ];
    hydraPlatforms = [ ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
