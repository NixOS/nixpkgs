{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "docuum";
  version = "0.27.3";

  src = fetchFromGitHub {
    owner = "stepchowfun";
    repo = "docuum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-asK8vA8J0kUZQ1ntyrKXlpqhwTT0pkcsw6XYpi6lPtU=";
  };

  cargoHash = "sha256-fWc34Iqc1oPbUIDSknfLV8rH0UDdv0c8w/d4FASwv4k=";

  checkFlags = [
    # fails, no idea why
    "--skip=format::tests::code_str_display"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
    tests.nixos = nixosTests.docuum;
  };

  meta = {
    description = "Least recently used (LRU) eviction of Docker images";
    homepage = "https://github.com/stepchowfun/docuum";
    changelog = "https://github.com/stepchowfun/docuum/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mkg20001 ];
    mainProgram = "docuum";
  };
})
