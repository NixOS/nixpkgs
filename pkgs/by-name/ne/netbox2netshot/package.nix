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
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "scaleway";
    repo = "netbox2netshot";
    rev = version;
    hash = "sha256-zi/on31uYSW3XhIZzKMkxIj0QZxUzoOcpRR8w5LFH90=";
  };

  cargoHash = "sha256-qMIGCE3YsV+ZihqBpayrxddsSkmFPldgYNHnAK5semA=";

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
