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

  useFetchCargoVendor = true;
  cargoHash = "sha256-BSXbFKR4AOKhssj+m5PIfgaoeRVDK+KRkApi8FUa8jg=";

  meta = with lib; {
    description = "Rust implementation of the Starlark language";
    homepage = "https://github.com/facebook/starlark-rust";
    changelog = "https://github.com/facebook/starlark-rust/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "starlark";
  };
}
