{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, wrapGAppsHook
, dbus
, libGL
, libX11
, libXcursor
, libXi
, libXrandr
, udev
, unzip
, alsa-lib
}:

stdenv.mkDerivation rec {
  pname = "cryptowatch-desktop";
  version = "0.7.1";

  src = fetchurl {
    url = "https://cryptowat.ch/desktop/download/linux/${version}";
    hash = "sha256-ccyHfjp00CgQH+3SiDWx9yE1skOj0RWxnBomHWY/IaU=";
  };

  unpackPhase = "unzip $src";

  nativeBuildInputs = [
    autoPatchelfHook
    wrapGAppsHook
    unzip
  ];

  buildInputs = [
    dbus
    udev
    alsa-lib
  ];

  sourceRoot = ".";

  installPhase = ''
    install -m755 -D cryptowatch_desktop $out/bin/cryptowatch_desktop
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL libX11 libXcursor libXrandr libXi ]}"
    )
  '';

  meta = with lib; {
    homepage = "https://cryptowat.ch";
    description = "Application for visualising real-time cryptocurrency market data";
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    maintainers = with maintainers; [ livnev kashw2 ];
  };
}
