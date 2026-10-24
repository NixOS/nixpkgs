{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-json";
  version = "1.9.16";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-json";
    tag = finalAttrs.version;
    hash = "sha256-NSaP8902m3M0FRB0DqdANnrxeVYJS+FG8Mwz0D72PjY=";
  };

  npmDepsHash = "sha256-ZMLbQV0KPZOs1UBtNRXidkucloQpH2f4z/OmIzmT38k=";

  npmBuildScript = "prepare";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "JSON language extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-json";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
