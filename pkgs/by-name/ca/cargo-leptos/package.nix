{
  fetchFromGitHub,
  lib,
  stdenv,
  rustPlatform,
  perl,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-leptos";
  version = "0.2.35";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = "cargo-leptos";
    rev = "v${version}";
    hash = "sha256-CNktytEm6+5QTPAlxNz07+s7gue9dA5zZM82YQOWFSw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-O/JyB47UP6rLeAG1rt1dXhaKfZ71QPg7qAeciHAvrAk=";

  # https://github.com/leptos-rs/cargo-leptos#dependencies
  buildFeatures = [ "no_downloads" ]; # cargo-leptos will try to install missing dependencies on its own otherwise
  doCheck = false; # Check phase tries to query crates.io

  nativeBuildInputs = [ perl ]; # Compile vendored-openssl

  # Fix for C++ compiler version on darwin for wasm-opt
  preBuild = lib.optionalString stdenv.isDarwin ''
    export CRATE_CC_NO_DEFAULTS=1
  '';

  meta = with lib; {
    description = "Build tool for the Leptos web framework";
    mainProgram = "cargo-leptos";
    homepage = "https://github.com/leptos-rs/cargo-leptos";
    changelog = "https://github.com/leptos-rs/cargo-leptos/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ benwis ];
  };
}
