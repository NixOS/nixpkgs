{ qemu, fetchFromGitHub, lib }: let
  src = fetchFromGitHub {
    owner = "riscv";
    repo = "riscv-qemu";
    rev = "713f2c116481d568702759bcb1b7fed835a2d575";
    sha256 = "0y4zrgidpc19pxwqqxcmj0ld50fdkf8b8c87xfcn88zrk8798qz4";
    fetchSubmodules = true;
  };
  version = "2.11.50";
  date = "20180203";
  revCount = "57991";
  shortRev = "713f2c1164";
in lib.overrideDerivation qemu (orig: {
  name = "${(builtins.parseDrvName qemu.name).name}-${version}pre${revCount}_${shortRev}";
  inherit src;
})
