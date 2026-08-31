{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgconf,
  imagemagick,
  libimagequant,
  luajit,
  makeBinaryWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cwal";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "nitinbhat972";
    repo = "cwal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hQ2N/lSUp1FduYG0tPOVP68QeOQyi7luEkys3A697LU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkgconf
    makeBinaryWrapper
  ];

  buildInputs = [
    imagemagick
    libimagequant
    luajit
  ];

  postPatch = ''
    substituteInPlace config.h \
      --replace-fail '#define INSTALL_DIR "/usr"' \
      "#define INSTALL_DIR \"$out\""
  '';

  buildPhase = ''
    runHook preBuild
    cc nob.c -o nob
    ./nob build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    ./nob install
    runHook postInstall
  '';

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
