{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation rec {
  version = "0.15.3";
  pname = "liburcu";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    hash = "sha256-Jmh+yE4+EUdZRUyISgir6ved7AmwQYld30xF7BUKy20=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeCheckInputs = [ perl ];

  enableParallelBuilding = true;

  preCheck = "patchShebangs tests/unit";
  doCheck = true;

  meta = {
    description = "Userspace RCU (read-copy-update) library";
    homepage = "https://lttng.org/urcu";
    changelog = "https://github.com/urcu/userspace-rcu/raw/v${version}/ChangeLog";
    license = lib.licenses.lgpl21Plus;
    # https://git.liburcu.org/?p=userspace-rcu.git;a=blob;f=include/urcu/arch.h
    platforms = lib.intersectLists lib.platforms.unix (
      lib.platforms.x86
      ++ lib.platforms.power
      ++ lib.platforms.s390
      ++ lib.platforms.arm
      ++ lib.platforms.aarch64
      ++ lib.platforms.mips
      ++ lib.platforms.m68k
      ++ lib.platforms.riscv
      ++ lib.platforms.loongarch64
    );
    maintainers = [ lib.maintainers.bjornfor ];
  };

}
