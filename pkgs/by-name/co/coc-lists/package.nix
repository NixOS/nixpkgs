{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-lists";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-lists";
    tag = finalAttrs.version;
    hash = "sha256-jt7JnGRXGgG+tbk0GySZeVAlOeTL/pX6+6WK3Qv6mYg=";
  };

  npmDepsHash = "sha256-9GndvIt7kQwT/wcS0qmeB0aIRNI/8UoW5b1JfoVAfn0=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Common lists for coc.nvim";
    homepage = "https://github.com/neoclide/coc-lists";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
