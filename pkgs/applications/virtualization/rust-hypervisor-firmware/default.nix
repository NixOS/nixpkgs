{
  lib,
  fetchFromGitHub,
  stdenv,
  lld,
}:

let
  arch = stdenv.hostPlatform.qemuArch;

  target = ./. + "/${arch}-unknown-none.json";

in

let
  cross = import ../../../.. {
    system = stdenv.hostPlatform.system;
    crossSystem = lib.systems.examples."${arch}-embedded" // {
      rust.rustcTarget = "${arch}-unknown-none";
      rust.platform =
        assert lib.assertMsg (builtins.pathExists target) "Target spec not found";
        lib.importJSON target;
    };
  };

  inherit (cross) rustPlatform;

in

rustPlatform.buildRustPackage rec {
  pname = "rust-hypervisor-firmware";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = "rust-hypervisor-firmware";
    tag = version;
    sha256 = "sha256-iLYmPBJH7I6EJ8VTUbR0+lZaebvbZlRv2KglbjKX76Q=";
  };

  cargoHash = "sha256-iqsU4t8Zz9UTtAu+a6kqwnPZ6qdGAriQ7hcU58KDQ8M=";

  # lld: error: unknown argument '-Wl,--undefined=AUDITABLE_VERSION_INFO'
  # https://github.com/cloud-hypervisor/rust-hypervisor-firmware/issues/249
  auditable = false;

  RUSTC_BOOTSTRAP = 1;

  nativeBuildInputs = [
    lld
  ];

  RUSTFLAGS = "-C linker=lld -C linker-flavor=ld.lld";

  # Tests don't work for `no_std`. See https://os.phil-opp.com/testing/
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/cloud-hypervisor/rust-hypervisor-firmware";
    description = "Simple firmware that is designed to be launched from anything that supports loading ELF binaries and running them with the PVH booting standard";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ astro ];
    platforms = [ "x86_64-none" ];
    mainProgram = "hypervisor-fw";
  };
}
