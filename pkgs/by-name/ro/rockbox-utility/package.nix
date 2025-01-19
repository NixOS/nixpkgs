{
  lib,
  stdenv,
  fetchgit,
  cmake,
  pkg-config,
  qt5,
  makeWrapper,
  cryptopp,
  libusb1,
  espeak ? null,
  withEspeak ? false,
}:

stdenv.mkDerivation rec {
  pname = "rbutil";
  version = "1.5.1";

  src = fetchgit {
    url = "git://git.rockbox.org/rockbox.git";
    rev = "rbutil_${version}";
    hash = "sha256-n5UnqBhRJ8R4AV2PLNTHuTIRuyDSqV1CjkQGlOHPIUY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    cryptopp
    libusb1
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qttools
  ] ++ lib.optional withEspeak espeak;

  cmakeFlags = [ "-Wno-dev" ];

  preConfigure = "cd utils";

  installPhase = ''
    install -Dm 755 rbutilqt/RockboxUtility -t $out/bin/
    install -Dm 644 -D $src/utils/rbutilqt/RockboxUtility.desktop -t $out/share/applications/
    install -Dm 644 $src/docs/logo/rockbox-clef.svg -t $out/share/pixmaps/

    wrapProgram $out/bin/RockboxUtility ${lib.optionalString withEspeak ''
      --prefix PATH : ${espeak}/bin
    ''}
  '';

  meta = with lib; {
    homepage = "https://www.rockbox.org";
    description = "Open source firmware for digital music players";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    mainProgram = "RockboxUtility";
    platforms = platforms.linux;
  };
}
