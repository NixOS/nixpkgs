{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hindsight-cli";
  version = "1.2.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "vectorize-io";
    repo = "hindsight";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fykytEgE0dapJhDtky4zyWwXgBgiuvufPkfdbnssi8g=";
  };

  sourceRoot = "${finalAttrs.src.name}/hindsight-cli";

  # Upstream does not commit a Cargo.lock for the CLI.
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--generate-lockfile"
      "--lockfile-metadata-path"
      "hindsight-cli"
    ];
  };

  meta = {
    description = "Command-line client for Hindsight, a long-term memory system for AI agents";
    homepage = "https://hindsight.vectorize.io";
    changelog = "https://github.com/vectorize-io/hindsight/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ brudel ];
    mainProgram = "hindsight";
  };
})
