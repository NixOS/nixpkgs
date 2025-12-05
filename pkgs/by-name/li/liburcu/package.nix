{
  lib,
  stdenv,
  fetchurl,
  perl,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  version = "0.15.5";
  pname = "liburcu";

  src = fetchurl {
    url = "https://lttng.org/files/urcu/userspace-rcu-${version}.tar.bz2";
    hash = "sha256-sveHqKg1EsMlmecc2rzFExRklHuCAUiWvRFBOy14LeE=";
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

  passthru.updateScript = gitUpdater {
    url = "https://git.lttng.org/userspace-rcu.git";
    rev-prefix = "v";
  };

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
