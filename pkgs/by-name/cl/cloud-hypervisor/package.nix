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

  useFetchCargoVendor = true;
  cargoHash = "sha256-wifctp30ApnxtRMlzksoSGrIJUT1cB0p1RBxfyITuZI=";

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
