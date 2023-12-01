{ lib, buildNimPackage, fetchFromGitHub, termbox, pcre }:

buildNimPackage (finalAttrs: {
  pname = "nimmm";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "joachimschmidt557";
    repo = "nimmm";
    rev = "v${finalAttrs.version}";
    sha256 = "168n61avphbxsxfq8qzcnlqx6wgvz5yrjvs14g25cg3k46hj4xqg";
  };

  lockFile = ./lock.json;

  buildInputs = [ termbox pcre ];

  meta = {
    description = "Terminal file manager written in Nim";
    homepage = "https://github.com/joachimschmidt557/nimmm";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.joachimschmidt557 ];
  };
})
