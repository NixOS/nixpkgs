{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "aiken";
  version = "1.1.11";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    rev = "v${version}";
    hash = "sha256-RCMUF9+dj+zJM1tyuUs2oOMk+5xdHrzWYejuOPd/Ngc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-R6jTr4F+ZbRracW8yQdpDHHerzbJy1jQYr/ttFSwCWc=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        CoreServices
        SystemConfiguration
      ]
    );

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Modern smart contract platform for Cardano";
    homepage = "https://aiken-lang.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "aiken";
  };
}
