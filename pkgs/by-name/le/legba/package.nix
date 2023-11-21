{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "legba";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "legba";
    rev = "v${version}";
    hash = "sha256-zZQZuMjyQEuXNor3g4P0YLvvj2DaU3A3/FUzCRJxnZQ=";
  };

  cargoHash = "sha256-qFdV4s//CsLi8tjQ36z3+ECMQR8evtCUKbauf6XpJ04=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl.dev ];

  # Paho C test fails due to permission issue
  doCheck = false;

  meta = with lib; {
    description = "A multiprotocol credentials bruteforcer / password sprayer and enumerator";
    homepage = "https://github.com/evilsocket/legba";
    changelog = "https://github.com/evilsocket/legba/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ mikaelfangel ];
    mainProgram = "legba";
  };
}
