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
  version = "44.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = "cloud-hypervisor";
    rev = "v${version}";
    hash = "sha256-2nA8bhezmGa6Gu420nxDrgW0SonTQv1WoGYmBwm7/bI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-e2VbzBPfoy5+YrqZ5mkbxMLpQIOG0x5tIhNG6Tv+u0M=";

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

  meta = with lib; {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${version}";
    license = with licenses; [
      asl20
      bsd3
    ];
    mainProgram = "cloud-hypervisor";
    maintainers = with maintainers; [
      offline
      qyliss
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
