{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  versionCheckHook,
  pkg-config,
  openssl,
  zstd,
  libgit2,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sem-vcs";
  version = "0.21.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ataraxy-labs";
    repo = "sem";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3lAcIxNM/4IFSj+7rMOjXsLZiIcAC4EESJBzWYkuDK0=";
  };

  cargoHash = "sha256-0/nTkOrGIWDJ3b1LbcIjR4yIZ8s/e5CcbgJ4m1AfxBs=";

  cargoRoot = "crates";
  buildAndTestSubdir = "crates";

  # Disable self-update feature for package-managed builds
  buildNoDefaultFeatures = true;

  cargoBuildFlags = [
    "--bin"
    "sem"

    "--bin"
    "sem-mcp"
  ];

  # Integration tests expect git repository state and telemetry configuration
  doCheck = false;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zstd
    libgit2
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic version control CLI";
    homepage = "https://github.com/ataraxy-labs/sem";
    changelog = "https://github.com/ataraxy-labs/sem/releases/tag/v${finalAttrs.version}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ malix ];
    mainProgram = "sem";
  };
})
