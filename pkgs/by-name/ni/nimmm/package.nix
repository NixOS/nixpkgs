{
  lib,
  buildNimPackage,
  fetchFromGitHub,
  termbox,
  pcre,
}:

buildNimPackage (finalAttrs: {
  pname = "nimmm";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "joachimschmidt557";
    repo = "nimmm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yq91rQlX6bfYHHw72+8m53PCD7hViLe56jAwPTeBBcg=";
  };

  lockFile = ./lock.json;

  buildInputs = [
    termbox
    pcre
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
