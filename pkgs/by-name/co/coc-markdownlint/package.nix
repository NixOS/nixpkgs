{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-06-02";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "9722582fc3dbff43535d6ba643df6f1c1211f2a7";
    hash = "sha256-oOGLxK9A46HVaqmmdHN9SisplhOkvegAunx5IWvOyDo=";
  };

  npmDepsHash = "sha256-s8MXIzIbq24UZ+SbLummedG6+4rvTRadCeWB8UiPlXM=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
