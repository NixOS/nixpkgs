{
  lib,
  bash,
  replaceVars,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pyrefly";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "facebook";
    repo = "pyrefly";
    tag = finalAttrs.version;
    hash = "sha256-tw4VQw0liyPjZBZxP7U79JLdJcSuitMr53lVdtje5KE=";
  };

  buildAndTestSubdir = "pyrefly";
  cargoHash = "sha256-+LwF0PHBU+do+eg84PGMEt3ri9LjMD+e2p82i2icwh4=";

  buildInputs = [ rust-jemalloc-sys ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  patches = [
    (replaceVars ./fix-shebang.patch { bash = lib.getExe bash; })
  ];

  # redirect tests writing to /tmp
  preCheck = ''
    export TMPDIR=$(mktemp -d)
  '';

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
