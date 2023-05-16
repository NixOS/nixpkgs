{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, dtc, openssl }:

rustPlatform.buildRustPackage rec {
  pname = "cloud-hypervisor";
<<<<<<< HEAD
  version = "34.0";
=======
  version = "31.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-+uicO6tPLzwlA4/Fao2J8n82Qnt3C6OfqRxn1pVh7XE=";
=======
    sha256 = "vQa43ic3pRzRfT8S9LQIO+VIo6AS2tEMT16CDrMw8R0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
<<<<<<< HEAD
      "acpi_tables-0.1.0" = "sha256-OdtnF2fV6oun3NeCkXdaGU3U7ViBcgFKqHKdyZsRsPA=";
      "kvm-bindings-0.6.0" = "sha256-wGdAuPwsgRIqx9dh0m+hC9A/Akz9qg9BM+p06Fi5ACM=";
      "kvm-ioctls-0.13.0" = "sha256-jHnFGwBWnAa2lRu4a5eRNy1Y26NX5MV8alJ86VR++QE=";
      "micro_http-0.1.0" = "sha256-w2witqKXE60P01oQleujmHSnzMKxynUGKWyq5GEh1Ew=";
      "mshv-bindings-0.1.1" = "sha256-9Q7IXznZ+qdf/d4gO7qVEjbNUUygQDNYLNxz2BECLHc=";
      "versionize_derive-0.1.4" = "sha256-oGuREJ5+FDs8ihmv99WmjIPpL2oPdOr4REk6+7cV/7o=";
      "vfio-bindings-0.4.0" = "sha256-8zdpLD9e1TAwG+m6ifS7/Fh39fAs5VxtnS5gUj/eKmY=";
      "vfio_user-0.1.0" = "sha256-b/gL6vPMW44O44lBIjqS+hgqVUUskBmttGk5UKIMgZk=";
      "vhost-0.7.0" = "sha256-KdVROh44UzZJqtzxfM6gwAokzY6El8iDPfw2nnkmhiQ=";
      "vm-fdt-0.2.0" = "sha256-lKW4ZUraHomSDyxgNlD5qTaBTZqM0Fwhhh/08yhrjyE=";
=======
      "acpi_tables-0.1.0" = "sha256-hP9Fi1K6hX0PkOuomjIzY+oOiPO/5YSNzo0Z98Syz2A=";
      "kvm-bindings-0.6.0" = "sha256-wGdAuPwsgRIqx9dh0m+hC9A/Akz9qg9BM+p06Fi5ACM=";
      "kvm-ioctls-0.13.0" = "sha256-jHnFGwBWnAa2lRu4a5eRNy1Y26NX5MV8alJ86VR++QE=";
      "micro_http-0.1.0" = "sha256-w2witqKXE60P01oQleujmHSnzMKxynUGKWyq5GEh1Ew=";
      "mshv-bindings-0.1.1" = "sha256-NwLPzX23nOe00qGoj1rLCWsJ5xEMmPUEtPVZNAYorWQ=";
      "versionize_derive-0.1.4" = "sha256-BPl294UqjVl8tThuvylXUFjFNjJx8OSfBGJLg8jIkWw=";
      "vfio-bindings-0.4.0" = "sha256-lKdoo/bmnZTRV7RRWugwHDFFCB6FKxpzxDEEMVqSbwA=";
      "vfio_user-0.1.0" = "sha256-IIwf7fmE6awpcgvWH/KWQY9tK3IHN+jkUGImQJFxnFM=";
      "vm-fdt-0.2.0" = "sha256-gVKGiE3ZSe+z3oOHR3zqVdc7XMHzkp4kO4p/WfK0VI8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    };
  };

  separateDebugInfo = true;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ] ++ lib.optional stdenv.isAarch64 dtc;

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
