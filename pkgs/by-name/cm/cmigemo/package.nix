{
  lib,
  stdenv,
  fetchFromGitHub,
  iconv,
  nkf,
  perl,
  which,
  skkDictionaries,
}:

stdenv.mkDerivation {
  pname = "cmigemo";
  version = "1.3e";

  src = fetchFromGitHub {
    owner = "koron";
    repo = "cmigemo";
    rev = "e0f6145f61e0b7058c3006f344e58571d9fdd83a";
    hash = "sha256-oQp1ziqF5TgXOdhRvEK7GqfhQQGaE3BBR8uE22ubRgE=";
  };

  nativeBuildInputs = [
    iconv
    nkf
    perl
    which
  ];

  postUnpack = ''
    cp ${skkDictionaries.l}/share/skk/SKK-JISYO.L source/dict/
  '';

  patches = [ ./no-http-tool-check.patch ];

  makeFlags = [ "INSTALL=install" ];

  buildFlags = [ (if stdenv.hostPlatform.isDarwin then "osx-all" else "gcc-all") ];

  installTargets = [ (if stdenv.hostPlatform.isDarwin then "osx-install" else "gcc-install") ];

  meta = {
    description = "Tool that supports Japanese incremental search with Romaji";
    mainProgram = "cmigemo";
    homepage = "https://www.kaoriya.net/software/cmigemo";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.cohei ];
    platforms = lib.platforms.all;
  };
}
