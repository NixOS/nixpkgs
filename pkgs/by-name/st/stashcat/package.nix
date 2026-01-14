{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,

  # Required dependencies for autoPatchelfHook
  gtk3,
  libnotify,
  nss,
  libxscrnsaver,
  libxtst,
  xdg-utils,
  at-spi2-atk,
  libuuid,
  libsecret,
  libappindicator,
  libgbm,
  alsa-lib,
  libGL,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "stashcat";
  version = "6.37.1";

  src = fetchurl {
    url = "http://deb.stashcat.com/repo01/dists/stashcat-dc/main/binary-amd64/stashcat-dc/${finalAttrs.pname}_${finalAttrs.version}_amd64.deb";
    hash = "sha256-nBBcG78No98TxTqFpZ01ydEyBUoBIw11Z9d+kzSL6ic=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    gtk3
    libnotify
    nss
    libxscrnsaver
    libxtst
    xdg-utils
    at-spi2-atk
    libuuid
    libsecret
    libappindicator
    libgbm
    alsa-lib
    libGL
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar --extract
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share,opt,bin}
    cp -r usr/share/* $out/share/
    cp -r opt/* $out/opt/

    ln -s $out/opt/Stashcat/stashcat $out/bin/stashcat

    substituteInPlace $out/share/applications/stashcat.desktop \
      --replace-fail "Exec=/opt/Stashcat/stashcat %U" "Exec=$out/opt/Stashcat/stashcat %U"

    runHook postInstall
  '';

  passthru.updateScript = ./update.py;

  meta = {
    description = "Stashcat Desktop Messenger";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    homepage = "https://stashcat.com/";
    mainProgram = "stashcat";
    maintainers = with lib.maintainers; [
      _365tuwe
    ];
    platforms = [ "x86_64-linux" ];
  };
})
