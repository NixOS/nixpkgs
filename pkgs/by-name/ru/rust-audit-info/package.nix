{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-audit-info";
  version = "0.5.2";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-g7ElNehBAVSRRlqsxkNm20C0KOMkf310bXNs3EN+/NQ=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-TvbFhFtdQ6fBNjIMgzQDVnK+IZThUJmht7r2zSmcllE=";

  meta = with lib; {
    description = "Command-line tool to extract the dependency trees embedded in binaries by cargo-auditable";
    mainProgram = "rust-audit-info";
    homepage = "https://github.com/rust-secure-code/cargo-auditable/tree/master/rust-audit-info";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
