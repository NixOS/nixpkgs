{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-02-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "63af4c902d6472572369c21dc46d73f47d626606";
    hash = "sha256-B5kd8p+muh6P9St5EMKPr7Bya3grWt/beg/2/2saVsI=";
  };

  npmDepsHash = "sha256-Jhiuu3GJuZUeL8QoEjCdW3mxYSMH33eIDzRTvsdQ83o=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
