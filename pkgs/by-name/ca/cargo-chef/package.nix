{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.73";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-zWyPVITx4wN0fd0bNVU5yt/ojsSVhbgIcoV6Z427RCA=";
  };

  cargoHash = "sha256-diox0Vafn8881tW4Z5Udm6U2lNQKe9m/H5bRTRN3aGs=";

  meta = with lib; {
    description = "Cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    mainProgram = "cargo-chef";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}
