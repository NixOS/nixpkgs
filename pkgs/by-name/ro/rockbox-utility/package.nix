{
  lib,
  stdenv,
  fetchurl,
  cryptopp,
  cmake,
  libusb1,
  makeWrapper,
  pkg-config,
  qt5,
  withEspeak ? false,
  espeak ? null,
  makeDesktopItem,
}:
stdenv.mkDerivation rec {
  pname = "rockbox-utility";
  version = "1.5.1";

  src = fetchurl {
    url = "https://download.rockbox.org/rbutil/source/RockboxUtility-v${version}-src.tar.bz2";
    hash = "sha256-guNO11a0d30RexPEAAQGIgV9W17zgTjZ/LNz/oUn4HM=";
  };

  patches = [
    (fetchurl {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-misc/rbutil/files/rbutil-1.5.1-cmake.patch";
      sha256 = "sha256-rA5avWAb5F9A4SLaurGgMcBsRj0UjVrw7egup9/cNQg=";
    })
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    pkg-config
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    cryptopp
    libusb1
    qt5.qtbase
    qt5.qttools
    qt5.qtmultimedia
  ] ++ lib.optional withEspeak espeak;

  preConfigure = "cd utils";

  installPhase = ''
    runHook preInstall

    install -Dm755 ../build/ipodpatcher $out/bin/ipodpatcher
    install -Dm755 ../build/sansapatcher $out/bin/sansapatcher
    install -Dm755 ../build/rbutilqt/RockboxUtility $out/bin/RockboxUtility
    install -Dm644 ../../docs/logo/rockbox-clef.svg $out/share/icons/hicolor/scalable/apps/rockbox-clef.svg

    wrapProgram $out/bin/RockboxUtility \
    ${lib.optionalString withEspeak ''
      --prefix PATH : ${espeak}/bin
    ''}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "RockboxUtility";
      desktopName = "Rockbox Utility";
      comment = "Automated installer tool for Rockbox";
      icon = "rockbox-clef";
      exec = "RockboxUtility";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    homepage = "https://www.rockbox.org";
    description = "Open source firmware for digital music players";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      AndersonTorres
      j0hax
    ];
    mainProgram = "RockboxUtility";
    platforms = lib.platforms.linux;
  };
}
