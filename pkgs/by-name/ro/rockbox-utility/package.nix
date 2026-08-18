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

stdenv.mkDerivation (finalAttrs: {
  pname = "rockbox-utility";
  version = "1.5.1";

  src = fetchurl {
    url = "https://download.rockbox.org/rbutil/source/RockboxUtility-v${finalAttrs.version}-src.tar.bz2";
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

  meta = {
    homepage = "https://www.rockbox.org";
    description = "Open source firmware for digital music players";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ozkutuk ];
    mainProgram = "RockboxUtility";
    platforms = lib.platforms.linux;
  };
})
