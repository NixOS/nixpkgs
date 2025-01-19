{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "sendme";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f3OgG6PTv9UUT5Gn1hBTHRIATrlvzBz1pjJ6fuWiCXM=";
  };

  cargoHash = "sha256-lWir4B3zGi7GBp5Of01GeGMV0SXzMjxcPBFipnoRRRk=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      SystemConfiguration
    ]
  );

  meta = {
    description = "Tool to send files and directories, based on iroh";
    homepage = "https://iroh.computer/sendme";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ cameronfyfe ];
    mainProgram = "sendme";
  };
}
