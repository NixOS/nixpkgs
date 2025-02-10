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
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    rev = "v${version}";
    hash = "sha256-qM6rBBBwLUwB3g+jjT0R6z0473x929t2W8tOY663EcI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-bgf9iVqQ7HuUV+idlPxyuILmxjBi2ThihdeCLjhj8Hk=";

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
