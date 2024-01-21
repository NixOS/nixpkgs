{ lib, stdenv, fetchFromGitHub, cmake, qt5 }:

stdenv.mkDerivation (finalAttrs: {
  pname = "DOtherSide";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "filcuc";
    repo = "DOtherSide";
    rev = "v${finalAttrs.version}";
    hash = "sha256-o6RMjJz9vtfCsm+F9UYIiYPEaQn+6EU5jOTLhNHCwo4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qt5.qtbase qt5.qtdeclarative ];

  dontWrapQtApps = true;

  meta = finalAttrs.src.meta // {
    description =
      "C language library for creating bindings for the Qt QML language";
    homepage = "https://github.com/filcuc/DOtherSide";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.lgpl3Only;
  };
})
