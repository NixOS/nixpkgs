{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
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
  version = "2.14.0";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-2MOcJs7BO3vYJVHNUqIu/DWLiI4268+cG2DvHDo8L9M=";
  };

  nativeBuildInputs = [ pkg-config ];
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

  meta = with lib; {
    description = "Tracing tools (kernel + user space) for Linux";
    mainProgram = "lttng";
    homepage = "https://lttng.org/";
    license = with licenses; [
      lgpl21Only
      gpl2Only
    ];
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };

}
