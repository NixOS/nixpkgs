{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shellshot";
  version = "0.6.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lhenry-dev";
    repo = "shellshot";
    tag = "v${finalAttrs.version}";
    hash = "sha256-eBwdCP3Bu2puB9pz+a+MR8nDeQTYQoTvdq2hHsaQX0I=";
  };

  cargoHash = "sha256-a6DPo/1Q+LtgKwxP2FgcVyHcPrNLV61q58SCMKNGBUw=";

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
