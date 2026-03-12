{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  imagemagick,
  libimagequant,
  lua,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cwal";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nitinbhat972";
    repo = "cwal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ky7ng6yxa8aMKRjjSHzWU6UC4QfeOdS+/rQ3eA/wRPE=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    imagemagick
    libimagequant
    lua
  ];

  meta = {
    description = "Blazing-fast pywal-like color palette generator written in C";
    homepage = "https://github.com/nitinbhat972/cwal";
    license = lib.licenses.gpl3Only;
    mainProgram = "cwal";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ gustlik501 ];
  };
})
