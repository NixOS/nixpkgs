{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dotherside";
  version = "0.9.0";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "filcuc";
    repo = "dotherside";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o6RMjJz9vtfCsm+F9UYIiYPEaQn+6EU5jOTLhNHCwo4=";
  };

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtquickcontrols2
  ];

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  meta = with lib; {
    description = "C language library for creating bindings for the Qt QML language";
    homepage = "https://filcuc.github.io/dotherside";
    license = licenses.lgpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ toastal ];
  };
})
