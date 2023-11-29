{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "legba";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "legba";
    rev = "v${version}";
    hash = "sha256-/ASjvlsPQAPNZpzdTTyZYrcYImV2GS+SSfhSQP0K2n0=";
  };

  cargoHash = "sha256-QgnJ/oUpW4o2Hi2+xKfprxjCw4sho8kIyW+AUJ9pwuU=";

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
