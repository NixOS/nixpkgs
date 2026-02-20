{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  dtc,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "51.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = "cloud-hypervisor";
    rev = "v${version}";
    hash = "sha256-RdwQg6/EI+oGkyNXnu5t1q87oTXev25XpIaE+PWDTx4=";
  };

  cargoHash = "sha256-WoFdX1GrgbADm2zm269OGczaGktVXau1UP7vzxfNZPQ=";

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional stdenv.hostPlatform.isAarch64 dtc;
  checkInputs = [ openssl ];

  OPENSSL_NO_VENDOR = true;

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

  meta = {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${version}";
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
}
