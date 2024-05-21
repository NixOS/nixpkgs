{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, dtc, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "39.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-sMnfeICo/PhpljstTIj4CiE4QBuyVKYD9oWvWf0Ouew=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "acpi_tables-0.1.0" = "sha256-a6ojB2XVeH+YzzXRle0agg+ljn0Jsgyaf6TJZAGt8sQ=";
      "igvm-0.1.9" = "sha256-OztgRiv+//27MS9SqSBJPbrVlXihK2m9UkG4REZ9Vn0=";
      "micro_http-0.1.0" = "sha256-yIgcoEfc7eeS1+bijzkifaBxVNHa71Y+Vn79owMaKvM=";
      "mshv-bindings-0.1.1" = "sha256-US/AzS7iRUQijkGs1EG04Hk4Q7dPz65BeTMsI8rtMqw=";
      "vfio-bindings-0.4.0" = "sha256-k8Hf5y8MiTnd3k2iEgnnX/o8VdVS7prKlnssyEerVRM=";
      "vfio_user-0.1.0" = "sha256-LJ84k9pMkSAaWkuaUd+2LnPXnNgrP5LdbPOc1Yjz5xA=";
      "vm-fdt-0.3.0" = "sha256-9PywgSnSL+8gT6lcl9t6w7X4fEINa+db+H1vWS+gDOI=";
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
