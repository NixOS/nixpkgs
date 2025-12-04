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
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "dhovart";
    repo = "cargo-local-registry";
    rev = "v${version}";
    hash = "sha256-DzBD7N7GQZ9nhF22DnxRse0P8MUGReOcXHQ56KOqW6I=";
  };

  cargoHash = "sha256-9DW6DkWXoGvdHjxIwgXaQP9a5Kc90SdNDRNRq6G6pLg=";

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
    maintainers = [ ];
  };
}
