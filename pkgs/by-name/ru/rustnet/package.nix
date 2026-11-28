{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  versionCheckHook,
  darwin,
  elfutils,
  zlib,
  libbpf,
  libpcap,
  clangStdenv,
}:
let
  pname = "rustnet";
  version = "1.6.0";
in
rustPlatform.buildRustPackage.override
  (lib.optionalAttrs stdenv.hostPlatform.isLinux { stdenv = clangStdenv; })
  {
    inherit pname version;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "domcyrus";
      repo = "rustnet";
      tag = "v${version}";
      hash = "sha256-TobP3K5f3eL/lxi+sawt/i0WWbYrLows/JN+EdKdeLo=";
    };

    cargoHash = "sha256-RURFa1Vep+qa7MP9N/mJZbCJqN1dzqhhTZ6RMSl1BTI=";

    nativeBuildInputs = [
      pkg-config
      versionCheckHook
    ];

    buildInputs = [
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      elfutils
      libbpf
      libpcap
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Apple's libpcap fork, vanilla libpcap lacks the PKTAP symbols
      darwin.libpcap
    ];

    # Required for libbpf-sys to build correctly; eBPF support is Linux-only upstream
    hardeningDisable = lib.optionals stdenv.hostPlatform.isLinux [
      "zerocallusedregs"
    ];

    # Set environment variables for libbpf-sys
    env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
      LIBBPF_SYS_LIBRARY_PATH = "${libbpf}/lib";
      LIBBPF_SYS_INCLUDE_PATH = "${libbpf}/include";
    };

    checkFlags = lib.optionals stdenv.hostPlatform.isLinux [
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
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
    };
  }
