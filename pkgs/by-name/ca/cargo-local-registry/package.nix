{
  lib,
  rustPlatform,
  fetchFromGitHub,
  curl,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-local-registry";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "dhovart";
    repo = "cargo-local-registry";
    rev = "v${version}";
    hash = "sha256-hG6OSi0I7Y6KZacGR9MCC+e7YcDcvaVfR3LSOjqz23A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-YJWUur+Ydb3a8vmx4TL5rIsMisjnKb0m+a9O/zeTnC4=";

  nativeBuildInputs = [
    curl
    pkg-config
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    zlib
  ];

  # tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Cargo subcommand to manage local registries";
    mainProgram = "cargo-local-registry";
    homepage = "https://github.com/dhovart/cargo-local-registry";
    changelog = "https://github.com/dhovart/cargo-local-registry/releases/tag/${src.rev}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
