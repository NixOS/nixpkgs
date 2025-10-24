{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
  john,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "johnny";
  version = "2.2";

  src = fetchFromGitHub {
    owner = "openwall";
    repo = "johnny";
    rev = "v${version}";
    hash = "sha256-fwRvyQbRO63iVt9AHlfl+Cv4NRFQmyVsZUQLxmzGjAY=";
  };

  buildInputs = [
    john
    qt5.qtbase
  ];
  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
    qt5.wrapQtAppsHook
    qt5.qmake
  ];

  installPhase = ''
    install -D johnny $out/bin/johnny
    wrapProgram $out/bin/johnny \
      --prefix PATH : ${lib.makeBinPath [ john ]}
    install -D README $out/share/doc/johnny/README
    install -D LICENSE $out/share/licenses/johnny/LICENSE
    install -D resources/icons/johnny_128.png $out/share/pixmaps/johnny.png
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Johnny";
      desktopName = "Johnny";
      comment = "A GUI for John the Ripper";
      icon = "johnny";
      exec = "johnny";
      terminal = false;
      categories = [
        "Application"
        "System"
      ];
      startupNotify = true;
    })
  ];

  meta = with lib; {
    homepage = "https://openwall.info/wiki/john/johnny";
    description = "Open Source GUI frontend for John the Ripper";
    mainProgram = "johnny";
    license = licenses.bsd2;
    maintainers = with maintainers; [ Misaka13514 ];
    platforms = platforms.linux;
  };
}
