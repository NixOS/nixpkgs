{
  lib,
  fetchCrate,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "dotenvy";
  version = "0.15.7";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-virK/TpYBmwTf5UCQCqC/df8iKYAzPBfsQ1nQkFKF2Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-eDmSPl1wsEriOtesv0KpLlpdeJPSQzbwh+QeZcFzDbc=";

  cargoBuildFlags = [
    "--bin=dotenvy"
    "--features=cli"
  ];

  # just run unittests and skip doc-tests
  cargoTestFlags = [ "--lib" ];

  meta = {
    description = "Loads environment variables from a .env file";
    homepage = "https://github.com/allan2/dotenvy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ phlip9 ];
  };
}
