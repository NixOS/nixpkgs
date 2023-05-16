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
<<<<<<< HEAD
, alsa-lib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "cryptowatch-desktop";
<<<<<<< HEAD
  version = "0.7.1";

  src = fetchurl {
    url = "https://cryptowat.ch/desktop/download/linux/${version}";
    hash = "sha256-ccyHfjp00CgQH+3SiDWx9yE1skOj0RWxnBomHWY/IaU=";
=======
  version = "0.5.0";

  src = fetchurl {
    url = "https://cryptowat.ch/desktop/download/linux/${version}";
    sha256 = "0lr5fsd0f44b1v9f2dvx0a0lmz9dyivyz5d98qx2gcv3jkngw34v";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    alsa-lib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ livnev kashw2 ];
=======
    maintainers = with maintainers; [ livnev ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
