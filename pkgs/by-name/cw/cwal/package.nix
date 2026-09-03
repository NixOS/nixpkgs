{
  lib,
  stdenv,
  fetchFromGitHub,
  pkgconf,
  imagemagick,
  libimagequant,
  luajit,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cwal";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "nitinbhat972";
    repo = "cwal";
    rev = "v${finalAttrs.version}";
    hash = "sha256-n9v2EiW1wRMsYoNk+m20qQao52vvmD6NDM8Z/oEyjbU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkgconf
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
