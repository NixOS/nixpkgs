{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, alsa-lib
, coreutils
, db
, dpkg
, glib
, gtk3
, wrapGAppsHook
, libkrb5
, libsecret
, nss
, openssl
, udev
, xorg
, mesa
, libdrm
, libappindicator
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mailspring";
  version = "1.13.3";

  src = fetchurl {
    url = "https://github.com/Foundry376/Mailspring/releases/download/${finalAttrs.version}/mailspring-${finalAttrs.version}-amd64.deb";
    hash = "sha256-2F5k8zRRI6x1EQ0k8wvIq1Q3Lnrn2ROp/Mq+H7Vqzlc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook
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
      --replace dirname ${coreutils}/bin/dirname

    ln -s $out/share/mailspring/mailspring $out/bin/mailspring
    ln -s ${lib.getLib openssl}/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0

    runHook postInstall
  '';

  postFixup = /* sh */ ''
    substituteInPlace $out/share/applications/Mailspring.desktop \
      --replace Exec=mailspring Exec=$out/bin/mailspring
  '';

  meta = {
    description = "A beautiful, fast and maintained fork of Nylas Mail by one of the original authors";
    downloadPage = "https://github.com/Foundry376/Mailspring";
    homepage = "https://getmailspring.com";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      Mailspring is an open-source mail client forked from Nylas Mail and built with Electron.
      Mailspring's sync engine runs locally, but its source is not open.
    '';
    mainProgram = "mailspring";
    maintainers = with lib.maintainers; [ toschmidt ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
