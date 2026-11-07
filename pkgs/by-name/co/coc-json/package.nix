{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-json";
  version = "1.9.19";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-json";
    tag = finalAttrs.version;
    hash = "sha256-4wo821fApoDtgBGQBh+wDtO32l24yAT1ejxP7ASMVnk=";
  };

  npmDepsHash = "sha256-+ZNpOlSQY2ALRaYB7BSZF7h/3jKgey1hQG707Ff8FCU=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JSON language extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-json";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
