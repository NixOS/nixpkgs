{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "oxiduct";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "6543";
    repo = "oxiduct";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MeougKVPI/H244V1h1Q//8ceCbqY48qOZ6PhH3/sNfk=";
  };

  cargoHash = "sha256-B4f9ITgaiIfkCOc1637hjFVFzvPqHiVsJHbqfpf5r08=";

  # buildRustPackage exports an empty RUST_LOG, which oxiduct rejects
  preCheck = ''
    unset RUST_LOG
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;

  meta = {
    description = "TCP/UDP proxy with dead-connection detection";
    homepage = "https://github.com/6543/oxiduct";
    changelog = "https://github.com/6543/oxiduct/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = lib.maintainers._6543;
    mainProgram = "oxiduct";
  };
})
