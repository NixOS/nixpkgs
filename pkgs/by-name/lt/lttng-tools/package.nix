{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  popt,
  libuuid,
  liburcu,
  lttng-ust,
  kmod,
  libxml2,
}:

stdenv.mkDerivation rec {
  pname = "lttng-tools";
  version = "2.13.14";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-U733xK0H2/5mDuTZr/xj/kSuWemnPG96luD8oUDlrcs=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
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
