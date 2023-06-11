{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "adguardian";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "Lissy93";
    repo = "AdGuardian-Term";
    rev = version;
    hash = "sha256-r7dh31fZgcUBffzwoBqIoV9XhZOjJRb9aWZUuuiz7y8=";
  };

  cargoHash = "sha256-/fBLLqmKsoV9Kdsj6JFQwdkidc1TgYfvJP0Wx1po1ao=";

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
