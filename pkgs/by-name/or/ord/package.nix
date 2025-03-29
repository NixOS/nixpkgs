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
  pname = "ord";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "ordinals";
    repo = "ord";
    rev = version;
    hash = "sha256-95da/aoBhrQ/GaM4fojFufs6+OI2KLF6SGsSw6qtYUc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-PGC3R+iy3evp7BtEpyXDPvi6mlB7CGtd8uzfpkmHzMU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  dontUseCargoParallelTests = true;

  checkFlags = [
    "--skip=subcommand::server::tests::status" # test fails if it built from source tarball
  ];

  meta = with lib; {
    description = "Index, block explorer, and command-line wallet for Ordinals";
    homepage = "https://github.com/ordinals/ord";
    changelog = "https://github.com/ordinals/ord/blob/${src.rev}/CHANGELOG.md";
    license = licenses.cc0;
    maintainers = with maintainers; [ xrelkd ];
    mainProgram = "ord";
  };
}
