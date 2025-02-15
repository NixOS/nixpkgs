{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "hvm";
  version = "2.0.19";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-+Cx+2v4JrQflDBaNZ9Fu8734Zr4rrgtnojUS4dkx7Ck=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HpQQLFb9vUAGIEKrkGKOfUUNALYGnKCR3/HqA+qvamw=";

  meta = with lib; {
    description = "Massively parallel, optimal functional runtime in Rust";
    mainProgram = "hvm";
    homepage = "https://github.com/higherorderco/hvm";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
