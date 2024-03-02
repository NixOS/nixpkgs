{ stdenv, fetchzip, lib, dtc }:

stdenv.mkDerivation {
  pname = "kvmtool";
  version = "unstable-2023-07-12";

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/snapshot/kvmtool-106e2ea7756d980454d68631b87d5e25ba4e4881.tar.gz";
    hash = "sha256-wpc5DfHnui0lBVH4uOq6a7pXVUZStjNLRvauu6QpRvE=";
  };

  patches = [ ./strlcpy-glibc-2.38-fix.patch ];

  buildInputs = lib.optionals stdenv.hostPlatform.isAarch64 [ dtc ];

  enableParallelBuilding = true;

  makeFlags = [
    "prefix=${placeholder "out"}"
  ] ++ lib.optionals stdenv.hostPlatform.isAarch64 ([
    "LIBFDT_DIR=${dtc}/lib"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "CROSS_COMPILE=aarch64-unknown-linux-gnu-"
    "ARCH=arm64"
  ]);

  meta = with lib; {
    description = "A lightweight tool for hosting KVM guests";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/tree/README";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ astro mfrw ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "lkvm";
  };
}
