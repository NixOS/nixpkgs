{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  desktop-file-utils,
  dpkg,
  makeWrapper,
  libnotify,
  libX11,
  libXScrnSaver,
  libXext,
  libXtst,
  libuuid,
  libsecret,
  xdg-utils,
  xdg-utils-cxx,
  at-spi2-atk,
  # additional dependencies autoPatchelfHook discovered
  gtk3,
  alsa-lib,
  e2fsprogs,
  nss,
  libgpg-error,
  libjack2,
  libgbm,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eudic";
  version = "13.5.2";

  src = fetchurl {
    name = "eudic.deb";
    url = "https://www.eudic.net/download/eudic.deb?v=${finalAttrs.version}";
    hash = "sha256-UPkDRaqWF/oydH6AMo3t3PUT5VU961EPLcFb5XwOXVs=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    desktop-file-utils
    dpkg
    makeWrapper
  ];

  buildInputs = [
    libnotify
    libX11
    libXScrnSaver
    libXext
    libXtst
    libuuid
    libsecret
    xdg-utils
    xdg-utils-cxx
    at-spi2-atk
    # additional dependencies autoPatchelfHook discovered
    gtk3
    alsa-lib
    e2fsprogs
    nss
    libgpg-error
    libjack2
    libgbm
  ];

  installPhase = ''
    runHook preInstall

    rm -r usr/share/icons
    desktop-file-edit usr/share/applications/eusoft-eudic.desktop \
      --set-key="Exec" --set-value="eudic %F"
    mkdir -p $out/bin
    cp -r usr/share $out/share
    makeWrapper $out/share/eusoft-eudic/eudic $out/bin/eudic \
      --inherit-argv0 \
      --set GST_PLUGIN_PATH $out/share/eusoft-eudic/gstreamer-1.0

    runHook postInstall
  '';

  meta = {
    description = "Authoritative English Dictionary Software Essential Tools for English Learners";
    homepage = "https://www.eudic.net/v4/en/app/eudic";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ onedragon ];
    mainProgram = "eudic";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
