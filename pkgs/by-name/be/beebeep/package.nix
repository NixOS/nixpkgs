{
  lib,
  fetchzip,
  autoPatchelfHook,
  stdenv,
  qt5,
}:

stdenv.mkDerivation rec {
  pname = "beebeep";
  version = "5.8.6";

  src = fetchzip {
    url = "https://netix.dl.sourceforge.net/project/beebeep/Linux/beebeep-${version}-qt5-amd64.tar.gz";
    hash = "sha256-YDgFRXFBM1tjLP99mHYJadgccHJYYPAZ1kqR+FngLKU=";
  };

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    autoPatchelfHook
  ];

  buildInputs = with qt5; [
    qtbase
    qtmultimedia
    qtx11extras
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp * $out/bin
  '';

  meta = {
    homepage = "https://www.beebeep.net/";
    description = "Free office messenger that is indispensable in all those places where privacy and security are an essential requirement";
    mainProgram = "beebeep";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
}
