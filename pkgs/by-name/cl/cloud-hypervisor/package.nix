{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dtc,
  openssl,
  zstd,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cloud-hypervisor";
  version = "53.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = "cloud-hypervisor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fPTGf8bAITDA8QwllWbbGXA7tJ6p/SxRDfcBQVRvCTI=";
  };

  cargoHash = "sha256-+RbW/9ap/69MyODUk/bHBlH6ZuqYYIyKaarYSMQ2G7w=";

  patches = [
    ./musl-1.2.6.patch
  ];

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    zstd
  ]
  ++ lib.optional stdenv.hostPlatform.isAarch64 dtc;

  env.OPENSSL_NO_VENDOR = true;
  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  # test_infra has no riscv64 support
  # TODO: remove with v54 https://github.com/cloud-hypervisor/cloud-hypervisor/pull/8877/changes/3708887b57eeea120b94d4dbf2a8e99541bfb233
  cargoBuildFlags = lib.optionals stdenv.hostPlatform.isRiscV64 [
    "--workspace"
    "--exclude"
    "test_infra"
    "--exclude"
    "performance-metrics"
  ];

  cargoTestFlags = [
    "--workspace"
    "--exclude"
    "hypervisor" # /dev/kvm
    "--exclude"
    "net_util" # /dev/net/tun
    "--exclude"
    "vmm" # /dev/kvm
  ]
  ++ lib.optionals stdenv.hostPlatform.isRiscV64 [
    "--exclude"
    "test_infra"
    "--exclude"
    "performance-metrics"
    "--exclude"
    "cloud-hypervisor"
  ]
  ++ [
    "--"
    # io_uring syscalls are blocked by the Lix sandbox
    "--skip=formats"
    "--skip=io_impl::async_io::uring_data_io"
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  meta = {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    mainProgram = "cloud-hypervisor";
    maintainers = with lib.maintainers; [
      qyliss
      phip1611
    ];
    platforms = [
      "aarch64-linux"
      "riscv64-linux"
      "x86_64-linux"
    ];
  };
})
