{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "starlark-rust";
  version = "0.13.0";

  src = fetchCrate {
    pname = "starlark_bin";
    inherit version;
    hash = "sha256-1M3p5QHMOBgmdEyr31Bhv7X8UdUmoeL0o1hWaw2tahQ=";
  };

  cargoHash = "sha256-BSXbFKR4AOKhssj+m5PIfgaoeRVDK+KRkApi8FUa8jg=";

  meta = {
    description = "Rust implementation of the Starlark language";
    homepage = "https://github.com/facebook/starlark-rust";
    changelog = "https://github.com/facebook/starlark-rust/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "starlark";
  };
}
