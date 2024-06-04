{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, hunspell
, poppler
, qt5compat
, qttools
, qtwayland
, withLua ? true, lua
, withPython ? true, python3 }:

stdenv.mkDerivation rec {
  pname = "texworks";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "TeXworks";
    repo = "texworks";
    rev = "release-${version}";
    sha256 = "sha256-G8TVTVQPELyE6H9a6gWSyWHi653TWzUoaRdlfPnngM0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    hunspell
    poppler
    qt5compat
    qttools
  ] ++ lib.optional withLua lua
    ++ lib.optional withPython python3
    ++ lib.optional stdenv.isLinux qtwayland;

  cmakeFlags = [
    "-DQT_DEFAULT_MAJOR_VERSION=6"
  ] ++ lib.optional withLua "-DWITH_LUA=ON"
    ++ lib.optional withPython "-DWITH_PYTHON=ON";

  meta = with lib; {
    changelog = "https://github.com/TeXworks/texworks/blob/${src.rev}/NEWS";
    description = "Simple TeX front-end program inspired by TeXShop";
    homepage = "http://www.tug.org/texworks/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
    platforms = with platforms; linux;
    mainProgram = "texworks";
  };
}
