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
  version = "1.1.15";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    rev = "v${version}";
    hash = "sha256-zbtsSEWgzhMeRMLb/ocsbz28lYXbSgucnPLVB9z7iwo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-k4gjgeQTZQw0OU1bHJPWskeZ974pTJGaKaIpM5+lZeU=";

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
