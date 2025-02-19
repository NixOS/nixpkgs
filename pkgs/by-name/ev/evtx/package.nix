{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "evtx";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "omerbenamram";
    repo = "evtx";
    tag = "v${version}";
    hash = "sha256-ljEuFsLOwydLbx1DprJdBTL3cjFkhmuwr34da8LzG88=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-SbWKDC2vfsOQfZERHdzQ3BE1ks9/a+5BJU4X3TPBxXw=";

  postPatch = ''
    # CLI tests will fail in the sandbox
    rm tests/test_cli_interactive.rs
  '';

  meta = with lib; {
    description = "Parser for the Windows XML Event Log (EVTX) format";
    homepage = "https://github.com/omerbenamram/evtx";
    changelog = "https://github.com/omerbenamram/evtx/blob/v${version}/CHANGELOG.md";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "evtx_dump";
  };
}
