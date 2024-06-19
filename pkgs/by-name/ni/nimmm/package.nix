{ lib, buildNimPackage, fetchFromGitHub, termbox, pcre }:

buildNimPackage (finalAttrs: {
  pname = "nimmm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "joachimschmidt557";
    repo = "nimmm";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gRQWReZP7bpGX9fvueQaQkX8yMmngT5DT3o4ly9Ux1g=";
  };

  lockFile = ./lock.json;

  buildInputs = [ termbox pcre ];

  meta = {
    description = "Terminal file manager written in Nim";
    mainProgram = "nimmm";
    homepage = "https://github.com/joachimschmidt557/nimmm";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.joachimschmidt557 ];
  };
})
