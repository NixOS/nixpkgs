{
  lib,
  rustPlatform,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "hcom";
  version = "0.7.23";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aannoo";
    repo = "hcom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-58AcL/hOi8Fl1Nq6QBOyM7Uf7ZUjBabU4PBzZWo25Vo=";
  };

  cargoHash = "sha256-cGhssU75BrNmHqxYWvqRcjNxB70rxYHXBz3hZDY+was=";

  doCheck = true;
  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags = [
    # tries to read $PATH
    "--skip=shell_env::tests::resolver_discards_stderr_without_breaking_env_resolution"
    # tries to read shell pid
    "--skip=shell_env::tests::timeout_kills_shell_process_group"
  ];

  # tons of unit tests use local ports
  __darwinAllowLocalNetworking = true;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Let AI agents message, watch, and spawn each other across terminals";
    homepage = "https://github.com/aannoo/hcom";
    changelog = "https://github.com/aannoo/hcom/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Br1ght0ne ];
    mainProgram = "hcom";
  };
})
