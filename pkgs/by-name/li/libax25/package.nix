{
  lib,
  stdenv,
  fetchurl,
  glibc,
}:

stdenv.mkDerivation rec {
  pname = "libax25";
  version = "0.0.12-rc5";

  buildInputs = [ glibc ] ++ lib.optionals stdenv.hostPlatform.isStatic [ glibc.static ];

  # Due to recent unsolvable administrative domain problems with linux-ax25.org,
  # the new domain is linux-ax25.in-berlin.de
  src = fetchurl {
    url = "https://linux-ax25.in-berlin.de/pub/ax25-lib/libax25-${version}.tar.gz";
    hash = "sha256-vxV5GVDOHr38N/512ArZpnZ+a7FTbXBNpoSJkc9DI98=";
  };

  configureFlags = [ "--sysconfdir=/etc" ];

  LDFLAGS = lib.optionals stdenv.hostPlatform.isStatic [
    "-static-libgcc"
    "-static"
  ];

  meta = with lib; {
    description = "AX.25 library for hamradio applications";
    homepage = "https://linux-ax25.in-berlin.de/wiki/Main_Page";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ sarcasticadmin ];
    platforms = platforms.linux;
  };
}
