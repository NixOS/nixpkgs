{
  lib,
  stdenv,
  fetchurl,
  perl,
}:

stdenv.mkDerivation rec {
  version = "0.14.1";
  pname = "liburcu";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    hash = "sha256-IxrLE9xuwCPoNqDwZm9qq0fcYh7LHSzZ2cIvkiZ4q8A=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeCheckInputs = [ perl ];

  preCheck = "patchShebangs tests/unit";
  doCheck = true;

  meta = with lib; {
    description = "Userspace RCU (read-copy-update) library";
    homepage = "https://lttng.org/urcu";
    changelog = "https://github.com/urcu/userspace-rcu/raw/v${version}/ChangeLog";
    license = licenses.lgpl21Plus;
    # https://git.liburcu.org/?p=userspace-rcu.git;a=blob;f=include/urcu/arch.h
    platforms = intersectLists platforms.unix (
      platforms.x86
      ++ platforms.power
      ++ platforms.s390
      ++ platforms.arm
      ++ platforms.aarch64
      ++ platforms.mips
      ++ platforms.m68k
      ++ platforms.riscv
    );
    maintainers = [ maintainers.bjornfor ];
  };

}
