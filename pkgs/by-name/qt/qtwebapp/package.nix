{
  fetchFromGitHub,
  stdenv,
  lib,
  qt6,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qtwebapp";
  version = "1.9.0";
  src = fetchFromGitHub {
    owner = "fffaraz";
    repo = "QtWebApp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L6/M8klo7bDKKwKC2tCc9IqN0nYy+x2c5Es51LHD7z4=";
  };

  sourceRoot = "source/QtWebApp";

  postPatch = ''
    cat >>QtWebApp.pro <<EOF
    unix {
      target.path += $out/lib
      INSTALLS += target
    }
    EOF
  '';

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
  ];

  qmakeFlags = [ "QtWebApp.pro" ];

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "HTTP server library in C++, inspired by Java Servlets";
    homepage = "https://stefanfrings.de/qtwebapp/index-en.html";
    license = lib.licenses.lgpl3Plus;
  };
})
