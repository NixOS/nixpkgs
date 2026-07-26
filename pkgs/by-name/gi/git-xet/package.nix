{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  pkg-config,
  openssl,
  zlib,
  git,
  git-lfs,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "git-xet";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "xet-core";
    tag = "git-xet-v${finalAttrs.version}";
    hash = "sha256-PmAJg7R5IBvDUsQGyDWzUz4bAFsR5ET1pOncpBGiHl4=";
  };

  cargoHash = "sha256-2f2lLSYcvllIKvyMlT5hphhkb0QY70wdTvncC1Lf4NI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ];

  # Build only the git_xet package
  buildAndTestSubdir = "git_xet";

  nativeCheckInputs = [
    git
    git-lfs
  ];
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Git LFS plugin that uploads and downloads using the Xet protocol";
    homepage = "https://github.com/huggingface/xet-core/blob/main/git_xet/README.md";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "git-xet";
    maintainers = with lib.maintainers; [
      cybardev
    ];
  };
})
