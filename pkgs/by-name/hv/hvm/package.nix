{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "hvm";
  version = "2.0.22";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-AD8mv47m4E6H8BVkxTExyhrR7VEnuB/KxnRl2puPnX4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nLcT+o6xrxPmQqK7FQpCqTlxOOUA1FzqRGQIypcq4fo=";

  meta = with lib; {
    description = "Massively parallel, optimal functional runtime in Rust";
    mainProgram = "hvm";
    homepage = "https://github.com/higherorderco/hvm";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
  };
}
