{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfs-cli";
  version = "0.1.36";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KKidgJMijvcxp5Ek0gknEdr5paHyarXYAB75e7feKEQ=";
  };

  cargoHash = "sha256-CmPMjJc/yyn0csYsKJawzfc+Rkz2gYWCmJVkgJLz/pQ=";

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
