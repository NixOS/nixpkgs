{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-sbom";
  version = "0.10.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-2/5FCK5CCDVPemsALm6OSTfiCHGwxxp9o2R9kZ+WKP8=";
  };

  cargoHash = "sha256-99C9wFnQwQmJax89EjMU3E6xIh1eGiFiX1lF7HPdLQw=";

  doCheck = true;

  meta = {
    description = "Create software bill of materials (SBOM) for Rust";
    mainProgram = "cargo-sbom";
    homepage = "https://github.com/psastras/sbom-rs";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [
      shimun
    ];
  };
}
