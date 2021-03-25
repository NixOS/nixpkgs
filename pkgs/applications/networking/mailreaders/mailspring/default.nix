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
  version = "1.8.0";

  src = fetchurl {
    url = "https://github.com/Foundry376/Mailspring/releases/download/${version}/mailspring-${version}-amd64.deb";
    sha256 = "BtzYcHN87qH7s3GiBrsDfmuy9v2xdhCeSShu8+T9T3E=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    alsaLib
    db
    glib
    # We don't know why with trackerSupport the executable fail to launch, See:
    # https://github.com/NixOS/nixpkgs/issues/106732
    (gtk3.override {trackerSupport = false; })
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
    (lib.getLib udev)
  ];

  unpackPhase = ''
    dpkg -x $src .
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    cp -ar ./usr/share $out

    substituteInPlace $out/share/mailspring/resources/app.asar.unpacked/mailsync \
      --replace dirname ${coreutils}/bin/dirname

    ln -s $out/share/mailspring/mailspring $out/bin/mailspring
    ln -s ${openssl.out}/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0
  '';

  postFixup = /* sh */ ''
    substituteInPlace $out/share/applications/mailspring.desktop \
      --replace /usr/bin $out/bin
  '';

  meta = with lib; {
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
