{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, dtc, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "38.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Lhug7DCa+QutlvksL6EFQa04UK/sWebDIkqQmwPUpX4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "acpi_tables-0.1.0" = "sha256-syDq+db1hTne6QoP0vMGUv4tB0J9arQG2Ea2hHW1k3M=";
      "igvm-0.1.0" = "sha256-l+Qyhdy3b8h8hPLHg5M0os8aSkjM55hAP5nqi0AGmjo=";
      "kvm-bindings-0.7.0" = "sha256-hXv5N3TTwGQaVxdQ/DTzLt+uwLxFnstJwNhxRD2K8TM=";
      "micro_http-0.1.0" = "sha256-gyeOop6AMXEIbLXhJMN/oYGGU8Un8Y0nFZc9ucCa0y4=";
      "mshv-bindings-0.1.1" = "sha256-yWvkpOcW3lV47s+rWnN4Bki8tt8CkiPVZ0I36nrWMi4=";
      "versionize_derive-0.1.6" = "sha256-eI9fM8WnEBZvskPhU67IWeN6QAPg2u5EBT+AOxfb/fY=";
      "vfio-bindings-0.4.0" = "sha256-Dk4T2dMzPZ+Aoq1YSXX2z1Nky8zvyDl7b+A8NH57Hkc=";
      "vfio_user-0.1.0" = "sha256-LJ84k9pMkSAaWkuaUd+2LnPXnNgrP5LdbPOc1Yjz5xA=";
      "vm-fdt-0.2.0" = "sha256-lKW4ZUraHomSDyxgNlD5qTaBTZqM0Fwhhh/08yhrjyE=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isAarch64 dtc;

  OPENSSL_NO_VENDOR = true;

  cargoTestFlags = [
    "--workspace"
    "--bins" "--lib" # Integration tests require root.
    "--exclude" "net_util" # /dev/net/tun
    "--exclude" "vmm"      # /dev/kvm
  ];

  meta = with lib; {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${version}";
    license = with licenses; [ asl20 bsd3 ];
    mainProgram = "cloud-hypervisor";
    maintainers = with maintainers; [ offline qyliss ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
