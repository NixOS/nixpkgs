{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-yaml";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-yaml";
    tag = finalAttrs.version;
    hash = "sha256-JzIajdgVOVJupxmHrw9GuGDZS863YaUa5FomT2tqBpc=";
  };

  patches = [
    ./package-lock-fix.patch
  ];

  npmDepsHash = "sha256-2XFXeF2ork6cPrYU2avpXSoAvLa7If6AtYtBGoxL/2g=";

  npmBuildScript = "prepare";

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Yaml language server extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-yaml";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
