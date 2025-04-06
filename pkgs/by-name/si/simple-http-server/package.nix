{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "simple-http-server";
  version = "0.6.12";

  src = fetchFromGitHub {
    owner = "TheWaWaR";
    repo = "simple-http-server";
    rev = "v${version}";
    sha256 = "sha256-WaUBMGZaIjce83mskEtH9PLYDDlBL1MNoY8lz4++684=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-5oZTT2qBtupuF2thhfko7mgWLu+e7+P92V+DPsPZ1Ak=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  # Currently no tests are implemented, so we avoid building the package twice
  doCheck = false;

  meta = with lib; {
    description = "Simple HTTP server in Rust";
    homepage = "https://github.com/TheWaWaR/simple-http-server";
    changelog = "https://github.com/TheWaWaR/simple-http-server/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      figsoda
      mephistophiles
    ];
    mainProgram = "simple-http-server";
  };
}
