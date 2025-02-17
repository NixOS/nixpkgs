{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
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

  useFetchCargoVendor = true;
  cargoHash = "sha256-XjHOlpYSOwSXxbGp/xZVVcBGhprg4hh61L5dhVE5ODM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
    ];

  meta = with lib; {
    description = "Inventory synchronization tool between Netbox and Netshot";
    homepage = "https://github.com/scaleway/netbox2netshot";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "netbox2netshot";
  };
}
