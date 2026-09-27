{
  lib,
  rustPlatform,
  fetchFromGitHub,
  git,
  nix,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npc";
  version = "1.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "samestep";
    repo = "npc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qgg1WwxcpqxmK+xchIWbGQ/EXUJdYje9++CziTFnmtA=";
  };

  cargoHash = "sha256-cxkVBKqFmlHjUrmx2jbGmGgrrZLpVmi/o6HzDKckudQ=";

  env = {
    GIT_BIN = lib.getExe git;
    NIX_BIN = lib.getExe nix;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Nixpkgs channel history CLI";
    homepage = "https://github.com/samestep/npc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      samestep
      me-and
    ];
  };
})
