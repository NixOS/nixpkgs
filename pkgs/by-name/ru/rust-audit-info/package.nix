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

  cargoHash = "sha256-TvbFhFtdQ6fBNjIMgzQDVnK+IZThUJmht7r2zSmcllE=";

<<<<<<< HEAD
  meta = {
    description = "Command-line tool to extract the dependency trees embedded in binaries by cargo-auditable";
    mainProgram = "rust-audit-info";
    homepage = "https://github.com/rust-secure-code/cargo-auditable/tree/master/rust-audit-info";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Command-line tool to extract the dependency trees embedded in binaries by cargo-auditable";
    mainProgram = "rust-audit-info";
    homepage = "https://github.com/rust-secure-code/cargo-auditable/tree/master/rust-audit-info";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mit # or
      asl20
    ];
    maintainers = [ ];
  };
}
