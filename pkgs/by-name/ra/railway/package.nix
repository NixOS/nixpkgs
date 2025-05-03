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
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "railwayapp";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-2qVib63l+NSiHPD9qDoZiRG1t7SCyqJEUpUI60UMneA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-p9KH8UhblE4+bKJrkiHvAg77WI2f6KVbIJ4wuUniqDU=";

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
