{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustfs-cli";
  version = "0.1.39";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "rustfs";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mCuhQcoRxEbIWXM3oXBwtuFF+ZTFGX1yULbVgHMXu/A=";
  };

  cargoHash = "sha256-EAu73ThGyW/nh7WHPvNtS/b72OYFRmwfiU0DMRp3Wcg=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ aws-lc ];

  passthru.updateScript = nix-update-script { };

  __darwinAllowLocalNetworking = true;
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
