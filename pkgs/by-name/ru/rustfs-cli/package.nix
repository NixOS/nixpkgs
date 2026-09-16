{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfs-cli";
  version = "0.1.35";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KLFQxoQfIvXHmO6gUCV4c9xM10svYhjThZ15Ja47E04=";
  };

  cargoHash = "sha256-gP4f3L6t0FAUAISG20GG07wYCQ8AmogMWaQ15pyvAfY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A S3-compatible command-line client written in Rust";
    homepage = "https://github.com/rustfs/cli";
    changelog = "https://github.com/rustfs/cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.OR [
      lib.licenses.asl20
      lib.licenses.mit
    ];
    maintainers = with lib.maintainers; [
      marcel
      adamcstephens
    ];
    mainProgram = "rc";
  };
})
