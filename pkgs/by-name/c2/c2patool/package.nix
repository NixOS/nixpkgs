{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  git,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "c2patool";
  version = "0.16.5";

  src = fetchFromGitHub {
    owner = "contentauth";
    repo = "c2pa-rs";
    tag = "c2patool-v${finalAttrs.version}";
    hash = "sha256-W9I7I4sukKBg4seRyn9iXoNhkRoSKcjbpjgZjvQKCGw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-C5PkwMfP/MyO8QlQk0DwkU2Z/u/FdJIvwpE3gseUG/Q=";

  # use the non-vendored openssl
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    git
    pkg-config
  ];

  buildInputs = [ openssl ];

  # could not compile `c2pa` (lib test) due to 102 previous errors
  doCheck = false;

  checkFlags = [
    # These tests rely on additional executables to be compiled to "target/debug/".
    "--skip=test_fails_for_external_signer_failure"
    "--skip=test_fails_for_external_signer_success_without_stdout"
    "--skip=test_succeed_using_example_signer"

    # These tests require network access to "http://timestamp.digicert.com", which is disabled in a sandboxed build.
    "--skip=test_manifest_config"
    "--skip=test_fails_for_not_found_external_signer"
    "--skip=tool_embed_jpeg_report"
    "--skip=tool_embed_jpeg_with_ingredients_report"
    "--skip=tool_similar_extensions_match"
    "--skip=tool_test_manifest_ingredient_json"
  ];

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Command line tool for working with C2PA manifests and media assets";
    homepage = "https://github.com/contentauth/c2pa-rs/tree/main/cli";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ ok-nick ];
    mainProgram = "c2patool";
  };
})
