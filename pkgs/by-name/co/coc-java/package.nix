{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "coc-java";
  version = "1.56.0";

  src = fetchFromGitHub {
    owner = "neoclide";
    repo = "coc-java";
    tag = finalAttrs.version;
    hash = "sha256-ez2ZFFiHy4p56RT0RvdimSiX5SCPYzkn5FS3armOy/0=";
  };

  npmDepsHash = "sha256-GtRvLza13eB/jM1O7PIqKC9atp8s8dD6qHEPhd2S7Ds=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Java extension for coc.nvim";
    homepage = "https://github.com/neoclide/coc-java";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
