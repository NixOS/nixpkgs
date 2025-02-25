{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "dumbpipe";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7Q+X1NcpzhWEmsCFhebW5KhT7gpzxSEDrgEtAOvHkqk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-8V/8aX/PFeekRuXj/kxGS3TQwxMS4mUD3seZMqc8oUk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      SystemConfiguration
    ]
  );

  meta = with lib; {
    description = "Connect A to B - Send Data";
    homepage = "https://www.dumbpipe.dev/";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "dumbpipe";
  };
}
