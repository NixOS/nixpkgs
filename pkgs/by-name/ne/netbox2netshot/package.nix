{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "netbox2netshot";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "netbox2netshot";
    rev = version;
    hash = "sha256-4Leg7MaLSos2RjmxB6yVzxGju6OzNrChXdw5htppuZU=";
  };

  cargoHash = "sha256-XjHOlpYSOwSXxbGp/xZVVcBGhprg4hh61L5dhVE5ODM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Inventory synchronization tool between Netbox and Netshot";
    homepage = "https://github.com/scaleway/netbox2netshot";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "netbox2netshot";
  };
}
