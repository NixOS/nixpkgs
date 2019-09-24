{ stdenv, fetchurl, autoPatchelfHook,
  atomEnv, cups, db53, dpkg, gtk2, libkrb5, openssl, udev
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "mailspring";
  version = "1.6.3";

  src = fetchurl {
    url = "https://github.com/Foundry376/Mailspring/releases/download/${version}/mailspring-${version}-amd64.deb";
    sha256 = "0lahvfvxwqbnp12qqc6pzbv5vnr3fr9i11af8lqrdjsd1ylsb73r";
  };


  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    atomEnv.packages
    cups
    db53
    libkrb5
  ];

  runtimeDependencies = [
    openssl
    udev.lib
  ];

  unpackPhase = /* sh */ ''
    dpkg -x $src .
  '';

  installPhase = /* sh */ ''
    mkdir -p $out/{bin,lib}
    cp -ar ./usr/share $out
    ln -s $out/share/mailspring/mailspring $out/bin/mailspring
    ln -s ${openssl.out}/lib/libcrypto.so $out/lib/libcrypto.so.1.0.0
  '';

  postFixup = /* sh */ ''
    substituteInPlace $out/share/applications/mailspring.desktop \
      --replace /usr/bin $out/bin

    mv $out/share/mailspring/resources/app.asar.unpacked/mailsync.bin \
       $out/share/mailspring/resources/app.asar.unpacked/mailsync
  '';

  meta = with stdenv.lib; {
    description = "A beautiful, fast and maintained fork of Nylas Mail by one of the original authors";
    license = licenses.gpl3;
    maintainers = with maintainers; [ ];
    homepage = https://getmailspring.com;
    platforms = [ "x86_64-linux" ];
  };
}
