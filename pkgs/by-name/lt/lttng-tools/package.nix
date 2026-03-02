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
  version = "2.14.1";

  src = fetchurl {
    url = "https://lttng.org/files/lttng-tools/${pname}-${version}.tar.bz2";
    sha256 = "sha256-DmjrJ5I2IcS8Enz85AQi0oz35HP+32IprmwyulxbfG0=";
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
