{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  imagemagick,
  libimagequant,
  luajit,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cwal";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "nitinbhat972";
    repo = "cwal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-xsfSx0ctDR1uep+SPyfFU/aOvN8l0uGzVPsNL3+4vT8=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    imagemagick
    libimagequant
    luajit
  ];

  postFixup = ''
    wrapProgram $out/bin/cwal \
      --prefix XDG_DATA_DIRS : $out/share
  '';

  meta = {
    description = "Blazing-fast pywal-like color palette generator written in C";
    homepage = "https://github.com/nitinbhat972/cwal";
    license = lib.licenses.gpl3Only;
    mainProgram = "cwal";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      gustlik501
      nitinbhat972
    ];
  };
})
