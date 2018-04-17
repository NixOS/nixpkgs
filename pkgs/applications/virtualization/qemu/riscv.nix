{ qemu, fetchFromGitHub, lib }: let
  src = fetchFromGitHub {
    owner  = "riscv";
    repo   = "riscv-qemu";
    rev    = "f733c7b5f86147216e14aff90c03ccdd76056bef";
    sha256 = "1ppr9qqwi7qqh8m6dgk1hrzg8zri240il27l67vfayd8ijagb9zq";
    fetchSubmodules = true;
  };
  version = "2.11.92";
  revCount = "60378";
  shortRev = builtins.substring 0 9 src.rev;
  targets = [ "riscv32-linux-user" "riscv32-softmmu"
              "riscv64-linux-user" "riscv64-softmmu"
            ];
in lib.overrideDerivation qemu (orig: {
  name = "${(builtins.parseDrvName qemu.name).name}-${version}pre${revCount}_${shortRev}";
  inherit src;
# <<<<<<< HEAD
#   # https://github.com/riscv/riscv-qemu/pull/109
#   patches = [ ./no-etc-install.patch ./statfs-flags.patch ./riscv-initrd.patch ];
# =======
  # The pulseaudio and statfs patches are in 2.12.0+, which this is based on
  patches = [
    ./force-uid0-on-9p.patch
    ./no-etc-install.patch
  ];

  configureFlags = orig.configureFlags ++ [ "--target-list=${lib.concatStringsSep "," targets}" ];
  postInstall = null;
})
