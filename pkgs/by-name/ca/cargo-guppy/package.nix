{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage {
  pname = "cargo-guppy";
  version = "unstable-2023-10-04";

  src = fetchFromGitHub {
    owner = "guppy-rs";
    repo = "guppy";
    rev = "837d0ae762b9ae79cc8ca5d629842e5ca34293b4";
    sha256 = "sha256-LWU1yAD/f9w5m522vcKP9D2JusGkwzvfGSGstvFGUpk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nNbCQ/++gm2S+xFbE5t9U9gQR8E2fVWE4kh73wgbAwQ=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  cargoBuildFlags = [
    "-p"
    "cargo-guppy"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-guppy"
  ];

  meta = with lib; {
    description = "Command-line frontend for guppy";
    mainProgram = "cargo-guppy";
    homepage = "https://github.com/guppy-rs/guppy/tree/main/cargo-guppy";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
