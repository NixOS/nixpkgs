{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "melodeon";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "CDrummond";
    repo = "melodeon";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-CwJd77FAEcfCvxHeh3V1SIsgSam3S5WtpSLj9WrOOyI=";
    fetchSubmodules = true;
  };

  buildInputs = [
    qt6.qtbase
    qt6.qtwebengine
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
