{ lib, stdenv, fetchFromGitHub, fetchpatch
, rustPlatform, pkg-config, dtc, openssl
}:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "41.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CI7hWRZUexvmBZJ8cPXxZxwmcxLnw6h9PFMhoaj9jh4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "acpi_tables-0.1.0" = "sha256-a6ojB2XVeH+YzzXRle0agg+ljn0Jsgyaf6TJZAGt8sQ=";
      "micro_http-0.1.0" = "sha256-yIgcoEfc7eeS1+bijzkifaBxVNHa71Y+Vn79owMaKvM=";
      "mshv-bindings-0.2.0" = "sha256-NYViItbjt1Q2G4yO3j37naHe9EJ+llkjrNt6w4zoiW8=";
      "vfio-bindings-0.4.0" = "sha256-mzdYH23CVWm7fvu4+1cFHlPhkUjh7+JlU/ScoXaDNgA=";
      "vfio_user-0.1.0" = "sha256-LJ84k9pMkSAaWkuaUd+2LnPXnNgrP5LdbPOc1Yjz5xA=";
      "vm-fdt-0.3.0" = "sha256-9PywgSnSL+8gT6lcl9t6w7X4fEINa+db+H1vWS+gDOI=";
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = lib.optional stdenv.hostPlatform.isAarch64 dtc;
  checkInputs = [ openssl ];

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
