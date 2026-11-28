{
  lib,
  stdenv,
  fetchgit,
  cmake,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "qbs";

  version = "3.4.0";

  src = fetchgit {
    url = "https://code.qt.io/qbs/qbs.git";
    tag = "v${version}";
    sha256 = "sha256-UNwKu1Z9Z6JsV0l/zayzHSyY1A/oBOJ18i2rxPlsUf0=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
  ];

  meta = {
    description = "Tool that helps simplify the build process for developing projects across multiple platforms";
    homepage = "https://wiki.qt.io/Qbs";
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [
      robinheghan
    ];
    platforms = lib.platforms.unix;
  };
}
