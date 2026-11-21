{
  lib,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  perl,
  aws-lc,
  pkg-config,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rust-web-server";
  version = "18.35.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bohdaq";
    repo = "rust-web-server";
    tag = finalAttrs.version;
    hash = "sha256-F1CvO7JQGxKcmnVqruUbBlQysT/tUW8diALW9+n6WS4=";
  };

  cargoHash = "sha256-rEOIOkYuKRxoqta28PadxvC2paSbMXt9bIgK3hMJ4QE=";

  # nixpkgs' cargo hook links system libraries: aws-lc-sys (TLS) the aws-lc
  # package (AWS_LC_SYS_USE_SYSTEM=1), zstd-sys zstd through pkg-config.
  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];
  buildInputs = [
    aws-lc
    zstd
  ];

  cargoBuildFlags = [
    "--bin"
    "rws"
  ];
  buildFeatures = [
    "acme"
    "auth"
  ];

  # The library's unit tests; the rest bind sockets or need the network.
  cargoTestFlags = [ "--lib" ];

  meta = {
    description = "Web server and reverse proxy with automatic HTTPS, HTTP/3, load balancing and auth";
    homepage = "https://rws8.tech";
    changelog = "https://github.com/bohdaq/rust-web-server/blob/${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "rws";
    maintainers = with lib.maintainers; [ bohdaq ];
  };
})
