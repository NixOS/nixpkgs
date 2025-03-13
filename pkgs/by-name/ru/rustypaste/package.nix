{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste";
    rev = "v${version}";
    sha256 = "sha256-Kv6hmqqGY9SssiT/MYmYCZ71N8CHFTT7K4q7eMdQTQU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-g7HoDPNP6DeV6NlC/F5KxBVMMgLw6zvVmOUe6yndRMQ=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  dontUseCargoParallelTests = true;

  checkFlags = [
    # requires internet access
    "--skip=paste::tests::test_paste_data"
    "--skip=server::tests::test_upload_remote_file"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Minimal file upload/pastebin service";
    homepage = "https://github.com/orhun/rustypaste";
    changelog = "https://github.com/orhun/rustypaste/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      seqizz
    ];
    mainProgram = "rustypaste";
  };
}
