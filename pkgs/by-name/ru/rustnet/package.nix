{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  elfutils,
  zlib,
  libbpf,
  libpcap,
  clangStdenv,
}:
let
  pname = "rustnet";
  version = "0.14.0";
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    tag = "v${version}";
    hash = "sha256-4C1bme1eA6S/0E4pqTMfaIe0eQNxYLO7Wk5GOxRGEbI=";
  };

  cargoHash = "sha256-Pdq6fah5lKw1gQoJk/L1keZq8EmbqJAZFO6yLcYSgS4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    elfutils
    libbpf
    libpcap
    zlib
  ];

  # Required for libbpf-sys to build correctly
  hardeningDisable = [
    "zerocallusedregs"
  ];
  # Set environment variables for libbpf-sys
  env = {
    LIBBPF_SYS_LIBRARY_PATH = "${libbpf}/lib";
    LIBBPF_SYS_INCLUDE_PATH = "${libbpf}/include";
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "High-performance, cross-platform network monitoring terminal UI tool built with Rust";
    homepage = "https://github.com/domcyrus/rustnet";
    changelog = "https://github.com/domcyrus/rustnet/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dvaerum ];
    mainProgram = "rustnet";
    platforms = lib.platforms.linux;
  };
}
