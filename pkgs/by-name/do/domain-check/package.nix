{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "domain-check";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "saidutt46";
    repo = "domain-check";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pHl/v8gnK6pphe/sNUVmA4KMJ6WAvTNLH02cf8amEMs=";
  };

  __structuredAttrs = true;

  cargoHash = "sha256-eoSxZa7GS8nSzDVLwP6b/Dd0ZSWwme9iXPj/kUOZnk4=";

  nativeInstallCheckInputs = [ versionCheckHook ];

  checkFlags = [
    # CLI tests
    "--skip=test_all_with_bootstrap_returns_more_than_32_tlds"
    "--skip=test_backward_compat_no_generation_flags"
    "--skip=test_config_detailed_info_respected_without_flag"
    "--skip=test_custom_preset_from_config"
    "--skip=test_env_detailed_info_respected_without_flag"
    # Tests require network access
    "--skip=example_nl_is_for_sale"
    "--skip=taken_domain_without_record_is_not_for_sale"
    "--skip=forsale::tests::annotate_looks_up_unknown_results"
    "--skip=forsale::tests::dns_lookup_example_nl_without_rdap"
    "--skip=forsale::tests::dns_lookup_large_rrset_falls_back_to_tcp"
    "--skip=forsale::tests::failed_check_with_record_becomes_unknown_for_sale"
    "--skip=test_all_flag_expands_beyond_hardcoded_tlds_with_bootstrap"
    "--skip=test_known_taken_domain_google_com"
    "--skip=test_only_for_sale_streaming_and_summary"
    "--skip=test_registered_it_domain_is_taken_via_whois"
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
