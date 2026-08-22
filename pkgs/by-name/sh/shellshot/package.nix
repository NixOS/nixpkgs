{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shellshot";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lhenry-dev";
    repo = "shellshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-enIt1iZAPJRxBFS4hyek17Oc9YxNsZi/wu3gxwFPQDQ=";
  };

  cargoHash = "sha256-Byy5IV0fQNReaKxjR7eF7hmNLo68TXvcLx9d6/hadk4=";

  checkFlags = [
    # Tries to make a HTTPS request that fails due to purposely missing CA trust-store in build sandbox
    "--skip=theme::tests::test_load_from_url_valid"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Transform your command-line output into clean, shareable images with a single command";
    homepage = "https://github.com/lhenry-dev/shellshot";
    changelog = "https://github.com/lhenry-dev/shellshot/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "shellshot";
  };
})
