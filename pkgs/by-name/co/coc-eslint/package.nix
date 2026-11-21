{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-eslint";
  version = "3.1.4";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-eslint";
    tag = finalAttrs.version;
    hash = "sha256-sM/Q3rCiXvPEAI/U1GMezYo8bepr5V3VOiAZy3Qhldc=";
  };

  npmDepsHash = "sha256-5DVkt6m/U2o1vncmkPHhyJygsFXR8oLK3D9bCy3M4Fs=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Eslint extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-eslint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
