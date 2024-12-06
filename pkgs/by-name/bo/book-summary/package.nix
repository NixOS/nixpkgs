{ lib
, rustPlatform
, fetchCrate
}:

rustPlatform.buildRustPackage rec {
  pname = "book-summary";
  version = "0.2.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-dxM6bqgHp4IaG03NriHvoT3al2u5Sz/I5ajlgzpjG1c=";
  };

  cargoHash = "sha256-QwydecdQaxvh6vWZvO30zgvvgUT6T5dvGRSmcuTUJmc=";

  meta = with lib; {
    description = "Book auto-summary for gitbook and mdBook";
    mainProgram = "book-summary";
    homepage = "https://github.com/dvogt23/book-summary";
    license = licenses.mit;
    maintainers = with teams; iog.members;
  };
}
