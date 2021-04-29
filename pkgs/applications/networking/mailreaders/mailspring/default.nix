{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, alsaLib
, coreutils
, db
, dpkg
, glib
, gtk3
, libkrb5
, libsecret
, nss
, openssl
, udev
, xorg
}:

stdenv.mkDerivation rec {
  pname = "mailspring";
  version = "1.9.1";

  src = fetchurl {
    url = "https://github.com/Foundry376/Mailspring/releases/download/${version}/mailspring-${version}-amd64.deb";
    sha256 = "mfpwDYRpFULD9Th8tI5yqb5RYWZJHarbWYpfKS3Q6mE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    alsaLib
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
  ];

  runtimeDependencies = [
    coreutils
    openssl
    (lib.getLib udev)
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
    ln -s ${openssl.out}/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0

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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ toschmidt doronbehar ];
    homepage = "https://getmailspring.com";
    downloadPage = "https://github.com/Foundry376/Mailspring";
    platforms = platforms.x86_64;
  };
}
