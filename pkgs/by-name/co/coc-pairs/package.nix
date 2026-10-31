{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-pairs";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-pairs";
    tag = finalAttrs.version;
    hash = "sha256-trHjKXkzbYwihDnuxLILZapFnhpbntclW7NgdV+Ok8M=";
  };

  patches = [
    ./package-lock-fix.patch
  ];

  npmDepsHash = "sha256-h4FecfEDjj5lwPyGz4LWGGHLpPu4EvxcjU69Zd7uvTs=";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Basic auto pairs extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-pairs";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
