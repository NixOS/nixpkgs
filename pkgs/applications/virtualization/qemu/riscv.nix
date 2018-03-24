{ qemu, fetchFromGitHub, lib }: let
  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-qemu";
    rev = "af435b709d4a5de3ec2e59ff4dcd05b0b295a730";
    sha256 = "1kqcsn8yfdg3zyd991i4v5dxznd1l4a4hjry9304lvsm3sz2wllw";
    fetchSubmodules = true;
  };
  version = "2.11.50";
  revCount = "58771";
  shortRev = "af435b709d";
  targets = [ "riscv32-linux-user" "riscv32-softmmu"
              "riscv64-linux-user" "riscv64-softmmu"
            ];
in lib.overrideDerivation qemu (orig: {
  name = "${(builtins.parseDrvName qemu.name).name}-${version}pre${revCount}_${shortRev}";
  inherit src;
  # https://github.com/riscv/riscv-qemu/pull/109
  patches = [ ./no-etc-install.patch ./statfs-flags.patch ./riscv-initrd.patch ];
  configureFlags = orig.configureFlags ++ [ "--target-list=${lib.concatStringsSep "," targets}" ];
  postInstall = null;
})
