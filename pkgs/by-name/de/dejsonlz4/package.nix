{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dejsonlz4";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "avih";
    repo = "dejsonlz4";
    rev = "v${finalAttrs.version}";
    sha256 = "0ggs69qamaama5mid07mhp95m1x42wljdb953lrwfr7p8p6f8czh";
  };

  buildPhase = ''
    ${stdenv.cc.targetPrefix}cc -o dejsonlz4 src/dejsonlz4.c src/lz4.c
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp dejsonlz4 $out/bin/
  '';

  meta = {
    description = "Decompress Mozilla Firefox bookmarks backup files";
    homepage = "https://github.com/avih/dejsonlz4";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ mt-caret ];
    platforms = lib.platforms.all;
    mainProgram = "dejsonlz4";
  };
})
