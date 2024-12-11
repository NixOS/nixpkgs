{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  git,
  versionCheckHook,
}:

rustPlatform.buildRustPackage rec {
  pname = "c2patool";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = "contentauth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-3OaCsy6xt2Pc/Cqm3qbbpr7kiQiA2BM/LqIQnuw73MY=";
  };

  cargoHash = "sha256-sei1sOhR35tkNW4rObLC+0Y5upxNo6yjRMLNcro0tRY=";

  # use the non-vendored openssl
  env.OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    git
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = with lib; {
    description = "Command line tool for displaying and adding C2PA manifests";
    homepage = "https://github.com/contentauth/c2patool";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ ok-nick ];
    mainProgram = "c2patool";
  };
}
