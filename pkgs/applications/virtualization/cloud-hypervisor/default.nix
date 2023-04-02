{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, dtc, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
  version = "30.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-emy4Sk/j9G+Ou/9h1Kgd70MgbpYMobAXyqAE2LJeOio=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isAarch64 dtc;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "acpi_tables-0.1.0" = "sha256-uWzw1FwIUCVvf9VfJYVA6VcMDEhA7sl6lME6N61k1ic=";
      "kvm-bindings-0.6.0" = "sha256-wGdAuPwsgRIqx9dh0m+hC9A/Akz9qg9BM+p06Fi5ACM=";
      "micro_http-0.1.0" = "sha256-w2witqKXE60P01oQleujmHSnzMKxynUGKWyq5GEh1Ew=";
      "mshv-bindings-0.1.1" = "sha256-ah6H43QRt39AmjpX9/2mxF3Jrbu14HH4CIUHTS1Mh0s=";
      "versionize_derive-0.1.4" = "sha256-BPl294UqjVl8tThuvylXUFjFNjJx8OSfBGJLg8jIkWw=";
      "vfio-bindings-0.4.0" = "sha256-NHzA+c1gAXtoCPLsZZ8mi+AGTpdxAfn5zlr04BCsbao=";
      "vfio_user-0.1.0" = "sha256-IIwf7fmE6awpcgvWH/KWQY9tK3IHN+jkUGImQJFxnFM=";
      "vm-fdt-0.2.0" = "sha256-dpUCj74FAjCM0BwxkSuByYIuqGcAisBy09Umhhyi0Jc=";
    };
  };

  OPENSSL_NO_VENDOR = true;

  # Integration tests require root.
  cargoTestFlags = [ "--bins" ];

  meta = with lib; {
    homepage = "https://github.com/cloud-hypervisor/cloud-hypervisor";
    description = "Open source Virtual Machine Monitor (VMM) that runs on top of KVM";
    changelog = "https://github.com/cloud-hypervisor/cloud-hypervisor/releases/tag/v${version}";
    license = with licenses; [ asl20 bsd3 ];
    maintainers = with maintainers; [ offline qyliss ];
    platforms = [ "aarch64-linux" "x86_64-linux" ];
  };
}
