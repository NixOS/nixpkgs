{
  stdenv,
  lib,
  pname,
  version,
  meta,
  fetchurl,
  autoPatchelfHook,
  alsa-lib,
  coreutils,
  db,
  dpkg,
  glib,
  gtk3,
  wrapGAppsHook3,
  libkrb5,
  libsecret,
  nss,
  openssl,
  udev,
  xorg,
  mesa,
  libdrm,
  libappindicator,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version meta;

  src = fetchurl {
    url = "https://github.com/Foundry376/Mailspring/releases/download/${finalAttrs.version}/mailspring-${finalAttrs.version}-amd64.deb";
    hash = "sha256-ZpmL6d0QkHKKxn+KF1OEDeAb1bFp9uohBobCvblE+L8=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    db
    glib
    gtk3
    libkrb5
    libsecret
    nss
    xorg.libxkbfile
    xorg.libXdamage
    xorg.libXScrnSaver
    xorg.libXtst
    xorg.libxshmfence
    mesa
    libdrm
  ];

  runtimeDependencies = [
    coreutils
    openssl
    (lib.getLib udev)
    libappindicator
    libsecret
  ];

  unpackPhase = ''
    runHook preUnpack

    dpkg -x $src .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,lib}
    cp -ar ./usr/share $out

    substituteInPlace $out/share/mailspring/resources/app.asar.unpacked/mailsync \
      --replace-fail dirname ${coreutils}/bin/dirname

    ln -s $out/share/mailspring/mailspring $out/bin/mailspring
    ln -s ${lib.getLib openssl}/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0

    runHook postInstall
  '';

  postFixup = # sh
    ''
      substituteInPlace $out/share/applications/Mailspring.desktop \
        --replace-fail Exec=mailspring Exec=$out/bin/mailspring
    '';
})
