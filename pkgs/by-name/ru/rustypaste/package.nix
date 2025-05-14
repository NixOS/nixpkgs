{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "rustypaste";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "orhun";
    repo = "rustypaste";
    rev = "v${version}";
    sha256 = "sha256-Jfi2Q6551g58dfOqtHtWxkbxwYV71f7MIuLB8RbaR94=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-10tBbn4XtdUNhfzb+KpwFGZAc7YVIEQRaqNLzJC1GGI=";

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
