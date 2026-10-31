{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenvNoCC,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "http-nu";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "cablehead";
    repo = "http-nu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1aGwrKlEkH8zDL7Tu9qD+NBWA1n0bpr0/7wNWinFhYs=";
  };

  cargoHash = "sha256-LGs4P6tomxWdNbel9nY5GfA4zv87RfBf7ztfQXI0hkU=";

  nativeBuildInputs = lib.optionals stdenvNoCC.hostPlatform.isDarwin [
    rustPlatform.bindgenHook
  ];

  # Most tests require sandbox-incompatible operations:
  # - Integration tests (server_test, server_missing_host) require network and curl binary
  # - test_handler requires temporary filesystem writes
  # - Only test_engine could run in sandbox, but selective enablement adds maintenance burden
  doCheck = false;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Serve a Nushell closure over HTTP";
    longDescription = ''
      http-nu is a tool that allows you to serve Nushell closures over HTTP,
      making it easy to create web services using Nushell's powerful scripting
      capabilities.
    '';
    homepage = "https://github.com/cablehead/http-nu";
    changelog = "https://github.com/cablehead/http-nu/blob/v${finalAttrs.version}/changes/v${finalAttrs.version}.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      cablehead
      cboecking
    ];
    mainProgram = "http-nu";
  };
})
