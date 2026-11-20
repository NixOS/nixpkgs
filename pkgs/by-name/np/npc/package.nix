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
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "samestep";
    repo = "npc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zimu94nLhfOa7kKBqpkOlGYvKN6NOIq4dr3qHQXHMG8=";
  };

  cargoHash = "sha256-HqQu/Gt5S9iBgHCFPLFlCOGzPM121Ai4HKhh/h49rZA=";

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
