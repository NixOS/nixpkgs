{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-pairs";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-pairs";
    tag = finalAttrs.version;
    hash = "sha256-GfM29wcINac3Otte/PEb1o1WS1LcywFlQ5s7leJv+gY=";
  };

  patches = [
    ./package-lock-fix.patch
  ];

  npmDepsHash = "sha256-Opj9s1OSjQftZKqUljzp+VAa495O5jMPUZEY0Bi/Njo=";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Basic auto pairs extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-pairs";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
