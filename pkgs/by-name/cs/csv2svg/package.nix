{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "csv2svg";
  version = "0.1.9";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-3VebLFkeJLK97jqoPXt4Wt6QTR0Zyu+eQV9oaLBSeHE=";
  };

  cargoHash = "sha256-RwpRxSD/oRAYD1udrHt3fy/SrrNUTVdGf+CdzQnJZ2U=";

  meta = {
    description = "Take a csv as input and outputs svg";
    homepage = "https://github.com/Canop/csv2svg";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "csv2svg";
  };
})
