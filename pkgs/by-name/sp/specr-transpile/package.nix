{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "specr-transpile";
  version = "0.1.25";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-yB4b7VaZ22zk8jhQijBOWRks22TV19q9IQNlVXyBlss=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-pMkvyMGfvLdj406xH/1+ZHE33iZDcmUUBjeSiIro0xY=";

  meta = with lib; {
    description = "Converts Specr lang code to Rust";
    mainProgram = "specr-transpile";
    homepage = "https://github.com/RalfJung/minirust-tooling";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
