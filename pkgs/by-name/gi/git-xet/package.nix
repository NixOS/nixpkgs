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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "xet-core";
    tag = "git-xet-v${finalAttrs.version}";
    hash = "sha256-XnCp9Dt4isFsT124ZVA/ID5y9l4bCSBQRrqrIPpv5Ow=";
  };

  cargoHash = "sha256-0xUik5zHO4T2PjFXrA0XHuy2892piE5Kiw2pcpa7xdY=";

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
