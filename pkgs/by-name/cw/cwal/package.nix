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
  version = "0.8.2";

  src = fetchFromGitHub {
    owner = "nitinbhat972";
    repo = "cwal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CvC7I0/Obn/IEXmbr8Hs7YqUk6NPgduJpDCNCHwU8lA=";
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
