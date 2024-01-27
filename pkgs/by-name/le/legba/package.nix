{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, samba
}:

rustPlatform.buildRustPackage rec {
  pname = "legba";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "legba";
    rev = "v${version}";
    hash = "sha256-7HDW5M0lsKbcQw3p/CYmUeX2xE4BZXUSNqa9Ab/ZP0I=";
  };

  cargoHash = "sha256-rkqwc8BILW/OIHa95skkG4IDlBfH3qX1ROJgcn8f2W0=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl.dev samba ];

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
