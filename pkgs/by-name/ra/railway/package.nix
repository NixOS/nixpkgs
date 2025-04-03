{
  lib,
  darwin,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
}:
let
  inherit (darwin.apple_sdk.frameworks) CoreServices Security SystemConfiguration;
in
rustPlatform.buildRustPackage rec {
  pname = "railway";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-o3AWcUKeOBiNsDSDV0XFzQ0rWpj7el4qX6iQKnqMPgg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-F+1ELwvtjnaQlvkfdKk7hnuEEde4NL/sUjPBExU+zds=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreServices
      Security
      SystemConfiguration
    ];

  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    mainProgram = "railway";
    description = "Railway.app CLI";
    homepage = "https://github.com/railwayapp/cli";
    changelog = "https://github.com/railwayapp/cli/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      Crafter
      techknowlogick
    ];
  };
}
