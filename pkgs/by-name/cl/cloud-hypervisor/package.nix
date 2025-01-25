{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  rustPlatform,
  pkg-config,
  dtc,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "43.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-drxJtlvBpkK3I7Ob3+pH4KLUq53GWXe1pmv7CI3bbP4=";
  };

  cargoPatches = [
    (fetchpatch {
      name = "kvm-ioctls-0.19.1.patch";
      url = "https://github.com/cloud-hypervisor/cloud-hypervisor/commit/eaa21946993276434403d41419a34e564935c8e9.patch";
      hash = "sha256-G7B0uGl/RAkwub8x1jNNgBrC0dwq/Gv46XpbtTZWD5M=";
    })
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-F6ukvSwMHRHXoZKgXEFnTAN1B80GsQDW8iqZAvsREr4=";

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
