{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  python3,
  babeltrace2,
  popt,
  libuuid,
  liburcu,
  lttng-ust,
  kmod,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "lttng-tools";
  version = "2.15.1";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-i21Lp64sA299r7tOKXF2d0EQePmp2WGy3HwboWJz6ek=";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  # Used by the test source generator during the build.
  makeFlags = [ "PYTHON=${lib.getExe python3}" ];

  buildInputs = [
    babeltrace2
    popt
    libuuid
    liburcu
    lttng-ust
    libxml2
    kmod
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Tracing tools (kernel + user space) for Linux";
    mainProgram = "lttng";
    homepage = "https://lttng.org/";
    license = with lib.licenses; [
      lgpl21Only
      gpl2Only
    ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
  };

}
