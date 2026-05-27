{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "melodeon";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "CDrummond";
    repo = "melodeon";
    tag = finalAttrs.version;
    hash = "sha256-jSzrz99TRcfVffnvr5PC2ipGl7g7mPc5NrxR15e9wOg=";
    fetchSubmodules = true;
  };

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
    qt6.qtsvg
  ];

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" ];

  meta = {
    description = "QWebEngine wrapper for MaterialSkin on Lyrion Music Server (formerly Logitech Media Server)";
    mainProgram = "melodeon";
    homepage = "https://github.com/CDrummond/melodeon";
    changelog = "https://github.com/CDrummond/melodeon/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ edgar-vincent ];
  };
})
