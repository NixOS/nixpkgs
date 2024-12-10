{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  libiconv,
  darwin,
  openssl,
  pkg-config,
  git,
}:
rustPlatform.buildRustPackage rec {
  pname = "c2patool";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner = "contentauth";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-1q0s8fwhlD891AhS1Sr2JBHi69SUMdP2cYslM/yFh8o=";
  };

  cargoHash = "sha256-4LfrafJd2W2HL/Q36lJ1zXw2CDLL79SLEuyKeFR9cUY=";

  # use the non-vendored openssl
  OPENSSL_NO_VENDOR = 1;

  nativeBuildInputs = [
    git
    pkg-config
  ];
  buildInputs =
    [
      openssl
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.Carbon
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
  installCheckPhase = ''
    $out/bin/c2patool --version | grep "${version}"
  '';

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
