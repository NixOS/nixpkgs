{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-KvMpuxQP4dofMXivMQnSgKnREv4rA8k2sj/TMuNycc0=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-aOret3lR8oEF1ViHvn2atkalY3n9YS6vN4TlX/7QtCc=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  # requires unstable rust features
  env.RUSTC_BOOTSTRAP = 1;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Fast type checker and IDE for Python";
    homepage = "https://github.com/facebook/pyrefly";
    license = lib.licenses.mit;
    mainProgram = "pyrefly";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      cybardev
      QuiNzX
    ];
  };
})
