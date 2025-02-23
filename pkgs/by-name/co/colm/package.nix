{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  gcc,
  asciidoc,
  python3Packages,
  autoreconfHook,
  bash,
}:

stdenv.mkDerivation {
  pname = "colm";
  version = "0.14.7-unstable-2023-03-13";

  src = fetchFromGitHub {
    owner = "adrian-thurston";
    repo = "colm";
    rev = "28b6e0a01157049b4cb279b0ef25ea9dcf3b46ed";
    hash = "sha256-Ype/KtbICGuueAvAErPc38HDxF1dmZ/bGjr+pc6bXLQ=";
  };

  postPatch = ''
    find . -type f -exec sed -i 's|^#!/bin/bash|#!${lib.getExe bash}|' {} \;
  '';

  configureFlags = [ "--enable-manual" ];

  nativeBuildInputs = [
    makeWrapper
    asciidoc
    autoreconfHook
    python3Packages.pygments
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=int-conversion";
  };

  doCheck = true;

  postInstall = ''
    wrapProgram $out/bin/colm \
      --prefix PATH ":" ${gcc}/bin
  '';

  meta = {
    description = "Programming language for the analysis and transformation of computer languages";
    mainProgram = "colm";
    homepage = "http://www.colm.net/open-source/colm";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ pSub ];
  };
}
