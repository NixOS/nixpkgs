{
  stdenv,
  lib,
  fetchFromGitHub,
  qtbase,
  qttools,
  qtsvg,
  qt5compat,
  opencascade-occt,
  libGLU,
  cmake,
  wrapQtAppsHook,
}:

stdenv.mkDerivation rec {
  pname = "librepcb";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-/Hw7ZTv2CbDcKuyI27wC46IxCcTnrXDS/Mf7csUTc7w=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qttools
    qtsvg
    qt5compat
    wrapQtAppsHook
    opencascade-occt
    libGLU
  ];
  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "Free EDA software to develop printed circuit boards";
    homepage = "https://librepcb.org/";
    maintainers = with maintainers; [
      luz
      thoughtpolice
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
