{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "domain-check";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "saidutt46";
    repo = "domain-check";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+gNuwJ0ohpAqpKygwIjBLpOIrW9QFFdyRo3mAFDbGJs=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-txgOQvoQ6ADD5VqxUrJ1yr4ycje6b6FCOxIMg3he8Gw=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # CLI tests
    "--skip=test_all_with_bootstrap_returns_more_than_32_tlds"
    "--skip=test_backward_compat_no_generation_flags"
    "--skip=test_config_detailed_info_respected_without_flag"
    "--skip=test_custom_preset_from_config"
    "--skip=test_env_detailed_info_respected_without_flag"
    # Tests require network access
    "--skip=test_known_taken_domain_google_com"
  ];

  doInstallCheck = true;

  meta = {
    description = "Tool to check domain availability";
    homepage = "https://github.com/saidutt46/domain-check";
    changelog = "https://github.com/saidutt46/domain-check/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "domain-check";
  };
})
