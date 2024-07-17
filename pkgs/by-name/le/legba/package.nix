{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  pkg-config,
  openssl,
  samba,
}:

rustPlatform.buildRustPackage rec {
  pname = "legba";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "legba";
    rev = "v${version}";
    hash = "sha256-yevQEbDuVaSsSfA3ug9rDeWtGjMvS+uD7qHguRVt4sg=";
  };

  cargoHash = "sha256-UBt4FP5zW+dijneHNaFJ80Ui5R+m+8aSwHTcqKDeEVg=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    openssl.dev
    samba
  ];

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
