{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  kdePackages,
  x11Support ? true,
}:

stdenv.mkDerivation rec {
  pname = "qview";
  version = "7.1";

  src = fetchFromGitHub {
    owner = "jurplel";
    repo = "qView";
    rev = version;
    hash = "sha256-EcXhwJcgBLdXa/FQ5LuENlzwnLw4Gt2BGlBO1p5U8tI=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qtimageformats
    qt6.qtsvg
    kdePackages.kimageformats
  ];

  qmakeFlags = [
    # See https://github.com/NixOS/nixpkgs/issues/214765
    "QT_TOOL.lrelease.binary=${lib.getDev qt6.qttools}/bin/lrelease"
  ]
  ++ lib.optionals (!x11Support) [ "CONFIG+=NO_X11" ];

  meta = with lib; {
    description = "Practical and minimal image viewer";
    mainProgram = "qview";
    homepage = "https://interversehq.com/qview/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ acowley ];
    platforms = platforms.all;
  };
}
