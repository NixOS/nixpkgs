{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  samba,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "legba";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "legba";
    rev = "v${version}";
    hash = "sha256-ioH/dy+d20p81iLLIcer+1fVib60TJ5Ezr6UlsL+F9g=";
  };

  cargoHash = "sha256-UaaB4d7sfHm+KJI05x/TYeEd8pTePJaFBMW7t7ShSqg=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    [
      openssl.dev
      samba
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  # Paho C test fails due to permission issue
  doCheck = false;

  meta = with lib; {
    description = "Multiprotocol credentials bruteforcer / password sprayer and enumerator";
    homepage = "https://github.com/evilsocket/legba";
    changelog = "https://github.com/evilsocket/legba/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "legba";
  };
}
