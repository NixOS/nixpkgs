{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "adguardian";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "Lissy93";
    repo = "AdGuardian-Term";
    rev = version;
    hash = "sha256-WxrSmCwLnXXs5g/hN3xWE66P5n0RD/L9MJpf5N2iNtY=";
  };

  cargoHash = "sha256-IPkKiXuFN0KFlcrrSjLmML+O5zCrVRKEqdyV2xBsCsg=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  meta = with lib; {
    description = "Terminal-based, real-time traffic monitoring and statistics for your AdGuard Home instance";
    mainProgram = "adguardian";
    homepage = "https://github.com/Lissy93/AdGuardian-Term";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
