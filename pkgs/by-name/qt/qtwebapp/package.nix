{
  fetchFromGitHub,
  stdenv,
  testers,
  validatePkgConfig,
  lib,
  qt6,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "qtwebapp";
  version = "1.9.1";
  src = fetchFromGitHub {
    owner = "fffaraz";
    repo = "QtWebApp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RbFgz2ed1eEVy44LX+milP4hPSeiabakU3TMvHYR7TU=";
  };

  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/QtWebApp";

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
    validatePkgConfig
  ];

  propagatedBuildInputs = [
    # For libs in the pkg-config, they must be
    # propagated so that packages that depend on
    # it can properly use it.
    qt6.qtbase
    qt6.qt5compat
  ];

  qmakeFlags = [ "QtWebApp.pro" ];

  pkgConfigFile = ./pkg-config.in;

  postInstall = ''
    mkdir -p "$out/lib/pkgconfig"
    cp "$pkgConfigFile" "$out/lib/pkgconfig/QtWebApp.pc"
    substituteInPlace "$out/lib/pkgconfig/QtWebApp.pc" \
      --subst-var out \
      --subst-var version

    mkdir -p "$out/include/QtWebApp/httpserver"
    cp httpserver/*.h "$out/include/QtWebApp/httpserver"

    mkdir -p "$out/include/QtWebApp/logging"
    cp logging/*.h "$out/include/QtWebApp/logging"

    mkdir -p "$out/include/QtWebApp/templateengine"
    cp templateengine/*.h "$out/include/QtWebApp/templateengine"
  '';

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = {
    maintainers = with lib.maintainers; [ xddxdd ];
    description = "HTTP server library in C++, inspired by Java Servlets";
    homepage = "https://stefanfrings.de/qtwebapp/index-en.html";
    license = lib.licenses.lgpl3Plus;
    pkgConfigModules = [
      "QtWebApp"
    ];
  };
})
