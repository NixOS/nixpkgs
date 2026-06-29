{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-06-13";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "13447a36779a3f30fca4f07ff6d2fb01a1a26695";
    hash = "sha256-u4KMKkyaRRaVdqleL8xYhZuQVkeIQPUXKxVW4ZCQ7Zw=";
  };

  npmDepsHash = "sha256-pavtHglfJYQ2ofZJTu+HoZMqdHWn6B08aRYiEM/f/Vk=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
