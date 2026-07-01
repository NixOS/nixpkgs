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
  version = "0.7.22";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "aannoo";
    repo = "hcom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nYJ/S6/yNaMU8dJ4NoQbNHa133Ui4mHxc/2Dfmzga90=";
  };

  cargoHash = "sha256-3wDLq7qymMO5NUK9ekbh9+ij+zp5Ny1lFcxVmHzti+4=";

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
