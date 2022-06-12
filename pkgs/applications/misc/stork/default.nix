{ lib
, rustPlatform
, fetchFromGitHub
, openssl
, pkg-config
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "stork";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "jameslittle230";
    repo = "stork";
    rev = "v${version}";
    sha256 = "sha256-itjRJLbRTwovK+HcNEzwViEDTJ1MoRRTvZD412XYVKk=";
  };

  cargoSha256 = "sha256-GaYdgC3Bf759ZPcZxoFG0nmCSz7aNHuqtyid6RS8Ui8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];

  meta = with lib; {
    description = "Impossibly fast web search, made for static sites";
    homepage = "https://github.com/jameslittle230/stork";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ chuahou ];
    # TODO: Remove once nixpkgs uses macOS SDK 10.14+ for x86_64-darwin
    # Undefined symbols for architecture x86_64: "_SecTrustEvaluateWithError"
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
