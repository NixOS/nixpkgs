{
  lib,
  stdenv,
  fetchgit,
  cmake,
  qt6,
}:

stdenv.mkDerivation rec {
  pname = "qbs";

  version = "3.3.1";

  src = fetchgit {
    url = "https://code.qt.io/qbs/qbs.git";
    tag = "v${version}";
    sha256 = "sha256-1W7+CZt1mtx8RdcZxhEhgi6+4/SPQAjic8yYXckBuJg=";
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
