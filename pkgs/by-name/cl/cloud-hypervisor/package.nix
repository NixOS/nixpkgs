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
  version = "54.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = "cloud-hypervisor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fhOFE82d6GWaR1/jeCNKHAcFgEc83+Gn9xF/czQFp0E=";
  };

  cargoHash = "sha256-t4x5FaOuUUG98TqTjumdisizTDcdueOh4da2kj7wUDo=";

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    zstd
  ]
  ++ lib.optional stdenv.hostPlatform.isAarch64 dtc;

  env.OPENSSL_NO_VENDOR = true;
  env.ZSTD_SYS_USE_PKG_CONFIG = true;

  cargoTestFlags = [
    "--workspace"
    "--exclude"
    "hypervisor" # /dev/kvm
    "--exclude"
    "net_util" # /dev/net/tun
    "--exclude"
    "vmm" # /dev/kvm
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
