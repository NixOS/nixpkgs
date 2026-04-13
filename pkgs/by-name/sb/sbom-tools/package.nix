{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sbom-tools";
  version = "0.1.19";

  src = fetchFromGitHub {
    owner = "sbom-tool";
    repo = "sbom-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-av2MC/CDOLdRLMz6WgO2RC7Pg4oBj8kRQCLRsAGsPqs=";
  };

  cargoHash = "sha256-lcigSHA4AvuE/vnpjOl6E3Nhux1vluGuniucL3VQCm8=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion \
      --cmd sbom-tools \
      --bash <($out/bin/sbom-tools completions bash) \
      --fish <($out/bin/sbom-tools completions fish) \
      --zsh <($out/bin/sbom-tools completions zsh)

    $out/bin/sbom-tools man > ./sbom-tools.1
    installManPage ./sbom-tools.1
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Semantic SBOM/CBOM diff, quality scoring, and TUI analysis tool for CycloneDX/SPDX formats";
    downloadPage = "https://github.com/sbom-tool/sbom-tools";
    homepage = "https://sbom.tools/";
    changelog = "https://github.com/sbom-tool/sbom-tools/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "sbom-tools";
  };
})
