{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-json";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-json";
    tag = finalAttrs.version;
    hash = "sha256-xEKIoYTEkwVuVvrk9kGXP7511ZMEL0WiEJxPhM8TOxc=";
  };

  npmDepsHash = "sha256-Y51mHIWJoxl4H6mo3ACllSgUOhmr8HqqthvcuTmNr1Y=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JSON language extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-json";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
