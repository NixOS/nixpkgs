{
  darwin,
  fetchFromGitHub,
  lib,
  rustPlatform,
  stdenv,
}:
let
  inherit (darwin.apple_sdk.frameworks)
    CoreServices
    SystemConfiguration
    Security
    ;
  inherit (lib) optionals;
  inherit (stdenv.hostPlatform) isDarwin;
in
rustPlatform.buildRustPackage rec {
  pname = "cargo-leptos";
  version = "0.2.28";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = "cargo-leptos";
    rev = "v${version}";
    hash = "sha256-SjpfM963Zux+H5QhK8prvDLuI56fP5PqX5gcVbthRx4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Da9ei4yAOfhSQmQgrUDZCmMeJXTfGnYhI1+L0JT/ECs=";

  buildInputs = optionals isDarwin [
    SystemConfiguration
    Security
    CoreServices
  ];

  # https://github.com/leptos-rs/cargo-leptos#dependencies
  buildFeatures = [ "no_downloads" ]; # cargo-leptos will try to install missing dependencies on its own otherwise
  doCheck = false; # Check phase tries to query crates.io

  meta = with lib; {
    description = "Build tool for the Leptos web framework";
    mainProgram = "cargo-leptos";
    homepage = "https://github.com/leptos-rs/cargo-leptos";
    changelog = "https://github.com/leptos-rs/cargo-leptos/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ benwis ];
  };
}
