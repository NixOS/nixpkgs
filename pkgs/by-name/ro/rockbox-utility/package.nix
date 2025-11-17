{
  lib,
  stdenv,
  fetchurl,
  cryptopp,
  libusb1,
  makeWrapper,
  pkg-config,
  qt5,
  cmake,
  withEspeak ? false,
  espeak ? null,
}:

stdenv.mkDerivation rec {
  pname = "rockbox-utility";
  version = "1.5.1";

  src = fetchurl {
    url = "https://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    hash = "sha256-guNO11a0d30RexPEAAQGIgV9W17zgTjZ/LNz/oUn4HM=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    cryptopp
    libusb1
    qt5.qtbase
    qt5.qtmultimedia
    qt5.qttools
  ]
  ++ lib.optional withEspeak espeak;

  cmakeDir = "../utils";

  patches = [
    ./rockbox-utility-fix-cmake.patch
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 rbutilqt/RockboxUtility $out/bin/rockboxutility
    ln -s $out/bin/rockboxutility $out/bin/RockboxUtility
    wrapProgram $out/bin/rockboxutility \
    ${lib.optionalString withEspeak ''
      --prefix PATH : ${espeak}/bin
    ''}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.rockbox.org";
    description = "Open source firmware for digital music players";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ozkutuk ];
    mainProgram = "RockboxUtility";
    platforms = platforms.linux;
  };
}
