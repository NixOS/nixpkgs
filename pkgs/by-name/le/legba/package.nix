{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, openssl
, samba
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "legba";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "legba";
    rev = "v${version}";
    hash = "sha256-emj2N3S26Nm0UiHGZIraCJN07rJNOMvdWRoUbHneknY=";
  };

  cargoHash = "sha256-viDfJ214Zf5segjrLSTbHav5T5e219NAF+MvuPow+JQ=";

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ openssl.dev samba ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
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
