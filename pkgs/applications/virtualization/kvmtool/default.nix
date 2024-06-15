{ stdenv, fetchgit, lib, dtc }:

stdenv.mkDerivation {
  pname = "kvmtool";
  version = "unstable-2024-06-14";

  src = fetchgit {
    url = "https://github.com/kvmtool/kvmtool.git";
    rev = "da4cfc3e540341b84c4bbad705b5a15865bc1f80";
    hash = "sha256-05tNsZauOXe1L1y1YchzvLZm3xOctPJhHCjyAyRnwy4=";
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
    description = "Lightweight tool for hosting KVM guests";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git/tree/README";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ astro mfrw peigongdsd ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "lkvm";
  };
}
