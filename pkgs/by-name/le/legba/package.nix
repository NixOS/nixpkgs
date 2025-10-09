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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "evilsocket";
    repo = "legba";
    rev = "v${version}";
    hash = "sha256-iynUReIWebfBkmWxbajsKbdfWSy+fzqF3NNssjtshYY=";
  };

  cargoHash = "sha256-clqOTFUOxZ1yt2YVgVDvsq2MhwMH7/s+jHSwt3buXgU=";

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

  meta = {
    description = "Multiprotocol credentials bruteforcer / password sprayer and enumerator";
    homepage = "https://github.com/evilsocket/legba";
    changelog = "https://github.com/evilsocket/legba/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ mikaelfangel ];
    mainProgram = "legba";
  };
}
