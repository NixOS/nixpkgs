{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-yaml";
  version = "1.9.3";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-yaml";
    tag = finalAttrs.version;
    hash = "sha256-PNNhDOIhN4uk505jabKoPeXfZHHLLhEy75wnRyRVeLA=";
  };

  patches = [
    ./package-lock-fix.patch
  ];

  npmDepsHash = "sha256-A+GgdQOF6vPO2mKV668iopXoZos1V7SawMtnig/8mYg=";

  npmBuildScript = "prepare";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Yaml language server extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-yaml";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
