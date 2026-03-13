{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  elfutils,
  zlib,
  libbpf,
  libpcap,
  clangStdenv,
}:
let
  pname = "rustnet";
  version = "0.18.0";
in
rustPlatform.buildRustPackage.override { stdenv = clangStdenv; } {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "domcyrus";
    repo = "rustnet";
    tag = "v${version}";
    hash = "sha256-79mYmb5gvqpjuLweEL+RJIf1jlfypO5zV1VC+BEeyp0=";
  };

  cargoHash = "sha256-ULYy4uCwmlOEO+Nlt3GO3cB891BOn9hUIfvr4UfeVzs=";

  nativeBuildInputs = [
    pkg-config
    versionCheckHook
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

  checkFlags = [
    "--skip=network::platform::linux::interface_stats::tests::test_get_all_stats"
    "--skip=network::platform::linux::interface_stats::tests::test_list_interfaces"
  ];

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
