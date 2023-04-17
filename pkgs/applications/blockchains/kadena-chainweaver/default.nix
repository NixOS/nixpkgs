{ stdenv
, lib
, fetchurl
, makeDesktopItem
, copyDesktopItems
, imagemagick
, writeScript
, bash
, dpkg
}:

stdenv.mkDerivation rec {
  pname = "kadena-chainweaver";
  version = "2.2.3";
  patchlevel = "0";

  src = fetchurl {
    url = "https://github.com/kadena-io/chainweaver/releases/download/v${version}/${pname}-linux-${version}.${patchlevel}.deb";
    sha256 = "sha256-+NZt59HBujBcYrlFNH8YR0RFHfpRSD13tYwUmXG0OsA=";
  };

  nativeBuildInputs = [ dpkg copyDesktopItems imagemagick ];

  desktopItems = [
    (makeDesktopItem {
      name = "Kadena Chainweaver";
      exec = "kadena-chainweaver";
      icon = "kadena-logo";
      desktopName = "Kadena Chainweaver ${version}";
      genericName = "Kadena Chainweaver Blockchain Wallet";
      categories = [ "Finance" ];
    })
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    runHook preInstall

    # copy full package, as it's already in LSB directory layout
    cp -rp usr $out

    # produce icons
    for n in 16 24 32 48 64 96 128 256; do
      size=$n"x"$n
      convert ./usr/share/chainweaver/static/img/kadena_blue_logo.png -resize $size kadena-logo.png
      install -Dm644 -t $out/share/icons/hicolor/$size/apps kadena-logo.png
    done;

    runHook postInstall
  '';

  meta = with lib; {
    description = "Kadena Chainweaver desktop wallet and web-based playground for the Pact language, including support for deployments to backends (blockchains, test servers)";
    homepage = "https://github.com/kadena-io/chainweaver";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    # As long as Kadena doesn't add a clear license, we must regard it as unfree (but open-source)
    # See: https://github.com/kadena-io/chainweaver/commit/54c821d8999e32590aa9a12355c7a4558fa557a0
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ derjohn ];
    platforms = [ "x86_64-linux" ];
  };
}

