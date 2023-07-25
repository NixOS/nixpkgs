{ stdenv, fetchgit, lib, dtc }:

stdenv.mkDerivation {
  pname = "kvmtool";
  version = "unstable-2023-04-06";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/linux/kernel/git/will/kvmtool.git";
    rev = "77b108c6a6f1c66fb7f60a80d17596bb80bda8ad";
    sha256 = "sha256-wPhqjVpc6I9UOdb6lmzGh797sdvJ5q4dap2ssg8OY5E=";
  };

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
    maintainers = with maintainers; [ astro ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
  };
}
