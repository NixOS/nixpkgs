{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  udevCheckHook,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "projecteur";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "gbin";
    repo = "Projecteur";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = false;
    hash = "sha256-4g0h46kKOyk7r0bF9l4T28NAE/NEjtYjdPfLZUsGK/M=";
  };

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtgraphicaleffects
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
    udevCheckHook
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX:PATH=${placeholder "out"}"
    "-DPACKAGE_TARGETS=OFF"
    "-DCMAKE_INSTALL_UDEVRULESDIR=${placeholder "out"}/lib/udev/rules.d"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Linux/X11 application for the Logitech Spotlight device (and similar devices)";
    homepage = "https://github.com/gbin/Projecteur";
    license = lib.licenses.mit;
    mainProgram = "projecteur";
    maintainers = with lib.maintainers; [
      benneti
    ];
    platforms = lib.platforms.linux;
  };
})
