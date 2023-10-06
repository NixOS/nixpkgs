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
  pname = "mailbase";
  version = "1.11.1";

  src = fetchurl {
    url = "https://github.com/CutestNekoAqua/Mailbase/releases/download/v1.11.1/mailspring-1.11.0-amd64.deb";
    hash = "sha256-wywox5vWzN+5Xp2nyUA6rsFnAuU9rc+YNs2z4WygrRs=";
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
      --replace Exec=mailspring Exec=$out/bin/mailspring \
      --replace Name=Mailspring Name=Mailbase
  '';

  meta = with lib; {
    description = "A beautiful, fast and maintained fork of Mailspring to fix CVE-2023-4863";
    longDescription = ''
      Mailbase is an open-source mail client forked from Mailspring and built with Electron 26.
      Mailspring's sync engine runs locally, but its source is not open. This fork fixes CVE-2023-4863
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aprl ];
    homepage = "https://github.com/CutestNekoAqua/Mailbase";
    platforms = [ "x86_64-linux" ];
  };
}
