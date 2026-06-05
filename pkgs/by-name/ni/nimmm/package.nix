{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  termbox,
  pcre,
}:

buildNimPackage (finalAttrs: {
  pname = "nimmm";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "joachimschmidt557";
    repo = "nimmm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-NK2OH5eAlcityUdz9p95Y7iNOX39ed0Krdns1+2NKLU=";
  };

  lockFile = ./lock.json;

  buildInputs = [
    termbox
  ];

  meta = {
    description = "Terminal file manager for Linux";
    mainProgram = "nimmm";
    homepage = "https://github.com/joachimschmidt557/nimmm";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.joachimschmidt557 ];
  };
})
