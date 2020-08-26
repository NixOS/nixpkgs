{ stdenv
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
  version = "1.7.8";

  src = fetchurl {
    url = "https://github.com/Foundry376/Mailspring/releases/download/${version}/mailspring-${version}-amd64.deb";
    sha256 = "207fbf813b6da018a5b848e5dc1194b5996daab39adbd873b2cecb0565c105ce";
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
    xorg.libXScrnSaver
    xorg.libXtst
  ];

  runtimeDependencies = [
    coreutils
    openssl
    udev.lib
  ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -ar ./usr/share $out

    substituteInPlace $out/share/mailspring/resources/app.asar.unpacked/mailsync \
      --replace realpath ${coreutils}/bin/realpath \
      --replace dirname ${coreutils}/bin/dirname

    ln -s $out/share/mailspring/mailspring $out/bin/mailspring
    ln -s ${openssl.out}/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0
  '';

  postFixup = /* sh */ ''
    substituteInPlace $out/share/applications/mailspring.desktop \
      --replace /usr/bin $out/bin
  '';

  meta = with stdenv.lib; {
    description = "A beautiful, fast and maintained fork of Nylas Mail by one of the original authors";
    longDescription = ''
      Mailspring is an open-source mail client forked from Nylas Mail and built with Electron.
      Mailspring's sync engine runs locally, but its source is not open.
    '';
    license = licenses.unfree;
    maintainers = with maintainers; [ toschmidt ];
    homepage = "https://getmailspring.com";
    downloadPage = "https://github.com/Foundry376/Mailspring";
    platforms = platforms.x86_64;
  };
}
