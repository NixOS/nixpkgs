{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "regex-cli";
  version = "0.2.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-lHjChrjjqO7pApj7OA8BM2XvmU3iS+kEMPYSfb/C61U=";
  };

  cargoHash = "sha256-9KLvVgmUun8tuAfxYMvAa5qpeXiOKe9JndZ81PmPpjA=";

  meta = with lib; {
    description = "Command line tool for debugging, ad hoc benchmarking and generating regular expressions";
    mainProgram = "regex-cli";
    homepage = "https://github.com/rust-lang/regex/tree/master/regex-cli";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
