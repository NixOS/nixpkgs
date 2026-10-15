{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  ncurses,
  readline,
  ronn,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "cpcfs";
  version = "0.85.4";

  src = fetchFromGitHub {
    owner = "derikz";
    repo = "cpcfs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Ig480GVCVfk1K+ttGw8n+LXpnGs/zV8NObsij4HPy2U=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    makeWrapper
    ncurses
    readline
    ronn
  ];

  env.NIX_CFLAGS_COMPILE = "-std=gnu89";

  postPatch = ''
    substituteInPlace Makefile \
      --replace '-ltermcap' '-lncurses' \
      --replace '-L /usr/lib/termcap' ' '
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    mkdir -p $out/man/man1
    cp cpcfs $out/bin
    ronn --roff ../template.doc --pipe > $out/man/man1/cpcfs.1
    runHook postInstall
  '';

  meta = {
    description = "Manipulating CPC dsk images and files";
    mainProgram = "cpcfs";
    homepage = "https://github.com/derikz/cpcfs/";
    license = lib.licenses.bsd2;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
