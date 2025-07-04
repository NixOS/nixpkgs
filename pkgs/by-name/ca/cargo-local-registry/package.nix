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
  version = "0.2.8";

  src = fetchFromGitHub {
    owner = "dhovart";
    repo = "cargo-local-registry";
    rev = "v${version}";
    hash = "sha256-XZ/OHcu3viS6LPQMyBDhxlpnC2oSgWQp7XtnKZCfMEw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-d3gWy2OR6mWluaT9Vl7UWzjHsTmTXzyts50PWVibI0o=";

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
