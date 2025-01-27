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

assert lib.assertMsg (builtins.pathExists target) "Target spec not found";

let
  cross = import ../../../.. {
    system = stdenv.hostPlatform.system;
    crossSystem = lib.systems.examples."${arch}-embedded" // {
      rust.rustcTarget = "${arch}-unknown-none";
      rust.platform = lib.importJSON target;
    };
  };

  inherit (cross) rustPlatform;

in

rustPlatform.buildRustPackage rec {
  pname = "rust-hypervisor-firmware";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "cloud-hypervisor";
    repo = pname;
    rev = version;
    sha256 = "sha256-hKk5pcop8rb5Q+IVchcl+XhMc3DCBBPn5P+AkAb9XxI=";
  };

  cargoHash = "sha256-edi6/Md6KebKM3wHArZe1htUCg0/BqMVZKA4xEH25GI=";

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
