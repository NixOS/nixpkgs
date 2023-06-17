{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "adguardian";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "Lissy93";
    repo = "AdGuardian-Term";
    rev = version;
    hash = "sha256-UZIwVvBBBj82IxGuZPKaNc/UZI1DAh5/5ni3fjiRF4o=";
  };

  cargoSha256 = "sha256-MnhikzQNeCjK5bCjePw8k7pf7RR63k1eZjobENlQd94=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Terminal-based, real-time traffic monitoring and statistics for your AdGuard Home instance";
    homepage = "https://github.com/Lissy93/AdGuardian-Term";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
