{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rinf_cli";
  version = "8.6.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-43pUpOiPJmf8gsagOkFhB+JvSKCtMV/V+LJaRfPjBh8=";
  };

  cargoHash = "sha256-qj8RoAxDfXmJDEiSqB8HjVGbDFuvDXHGhWQ3gwi05nE=";

  meta = {
    mainProgram = "rinf";
    description = "Rust for native business logic, Flutter for flexible and beautiful GUI";
    homepage = "https://rinf.cunarist.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ noah765 ];
  };
})
