{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dtc,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cloud-hypervisor";
  version = "51.1";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = "cloud-hypervisor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-H+sfuatB/7cAMwJcT8SKbTyISUdNyp8eSvvyvkKrjho=";
  };

  cargoHash = "sha256-E32SLJNQ9ssn7GwFpvpKot5nay+cr3rSZcKovjA5oJE=";

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional stdenv.hostPlatform.isAarch64 dtc;
  checkInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  cargoTestFlags = [
    "--workspace"
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
