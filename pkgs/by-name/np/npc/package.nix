{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  git,
  nix,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "npc";
  version = "1.0.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "samestep";
    repo = "npc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-V/yc0GtpLAtLflaD7MiREfmDsDEHzH7CY9cH0d1KKKs=";
  };

  cargoHash = "sha256-AcUet69xxrm8Vnb7vex8kDeGawx6j2vTPzCv6SrsIlM=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

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
