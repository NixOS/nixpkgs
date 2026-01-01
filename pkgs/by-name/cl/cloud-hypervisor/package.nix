{
  lib,
  stdenv,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchpatch,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  rustPlatform,
  pkg-config,
  dtc,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cloud-hypervisor";
<<<<<<< HEAD
  version = "50.0";
=======
  version = "49.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = "cloud-hypervisor";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-U2jNKdc+CWB/Z9TvAC0xfHDipfe4dhWjL9VXbBVaNJE=";
  };

  cargoHash = "sha256-M1jVvFo9Bo/ZFqaFtzwp2rusl1T1m7jAkEobOF0cnlA=";
=======
    hash = "sha256-bPPs/4XMcvOH4BGfQrjQdvgjGWae4UEZjzPKjalDN3w=";
  };

  patches = [
    (fetchpatch {
      name = "vsock-seccomp-Rust-1.90.patch";
      url = "https://github.com/cloud-hypervisor/cloud-hypervisor/commit/ec57aade1563075e37b8e9ccc0b85fe2c04a54b8.patch";
      hash = "sha256-M+I+ZbiNDV1a8Y46+/mPTyDlQgQS7G6ytvPgli0NhJ0=";
    })
    (fetchpatch {
      name = "vfio-user-seccomp-Rust-1.90.patch";
      url = "https://github.com/cloud-hypervisor/cloud-hypervisor/commit/95b8c6afdd6eec9810243f92ec1956dccfe305da.patch";
      hash = "sha256-kCP/Fu0Dg+GdnwyFQLqZWKlbqO9w4KRJcbV4sReSDYM=";
    })
  ];

  cargoHash = "sha256-5EK9V9yiF/UjmlYSKBIJgQOA1YU33ezicLikWYnKFAo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional stdenv.hostPlatform.isAarch64 dtc;
  checkInputs = [ openssl ];

<<<<<<< HEAD
  env.OPENSSL_NO_VENDOR = true;
=======
  OPENSSL_NO_VENDOR = true;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  cargoTestFlags = [
    "--workspace"
    "--bins"
    "--lib" # Integration tests require root.
    "--exclude"
    "hypervisor" # /dev/kvm
    "--exclude"
    "net_util" # /dev/net/tun
    "--exclude"
    "vmm" # /dev/kvm
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
      offline
      qyliss
    ];
    platforms = [
      "aarch64-linux"
      "riscv64-linux"
      "x86_64-linux"
    ];
  };
})
