{ fetchurl
, stdenv
, autoPatchelfHook
, makeWrapper
, lib
, copyDesktopItems
, libnotify
, libX11
, libXScrnSaver
, libXext
, libXtst
, libuuid
, libsecret
, xdg-utils
, xdg-utils-cxx
, at-spi2-atk
# additional dependencies autoPatchelfHook discovered
, gtk3
, alsa-lib
, e2fsprogs
, nss
, libgpg-error
, libjack2
, mesa
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "eudic";
  version = "13.5.2";

  src = fetchurl {
    url = "https://www.eudic.net/download/eudic.deb?v=${finalAttrs.version}";
    hash = "sha256-UPkDRaqWF/oydH6AMo3t3PUT5VU961EPLcFb5XwOXVs=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
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
    mesa
  ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.xz
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out/

    makeWrapper $out/share/eusoft-eudic/eudic $out/bin/eudic

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
