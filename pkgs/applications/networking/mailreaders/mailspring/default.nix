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

stdenv.mkDerivation rec {
  pname = "mailspring";
  version = "1.10.8";

  src = fetchurl {
    url = "https://github.com/Foundry376/Mailspring/releases/download/${version}/mailspring-${version}-amd64.deb";
    sha256 = "sha256-aXpPn6tpSOwWL/34qlpJ+on/H+X7303J1jwvwcVOTNs=";
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

  meta = with lib; {
    description = "A beautiful, fast and maintained fork of Nylas Mail by one of the original authors";
    longDescription = ''
      Mailspring is an open-source mail client forked from Nylas Mail and built with Electron.
      Mailspring's sync engine runs locally, but its source is not open.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ toschmidt ];
    homepage = "https://getmailspring.com";
    downloadPage = "https://github.com/Foundry376/Mailspring";
    platforms = [ "x86_64-linux" ];
  };
}
