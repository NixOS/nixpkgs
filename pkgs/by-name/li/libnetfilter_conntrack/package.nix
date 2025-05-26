{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libnfnetlink,
  libmnl,
}:

stdenv.mkDerivation rec {
  pname = "libnetfilter_conntrack";
  version = "1.1.0";

  src = fetchurl {
    url = "https://netfilter.org/projects/libnetfilter_conntrack/files/${pname}-${version}.tar.xz";
    hash = "sha256-Z+3LTrgmwvjcmK8I2r/2jzs9D+b7fZ0Kwe5+zOD+aU4=";
  };

  hardeningDisable = [ "trivialautovarinit" ];

  buildInputs = [ libmnl ];
  propagatedBuildInputs = [ libnfnetlink ];
  nativeBuildInputs = [ pkg-config ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Userspace library providing an API to the in-kernel connection tracking state table";
    longDescription = ''
      libnetfilter_conntrack is a userspace library providing a programming interface (API) to the
      in-kernel connection tracking state table. The library libnetfilter_conntrack has been
      previously known as libnfnetlink_conntrack and libctnetlink. This library is currently used
      by conntrack-tools among many other applications
    '';
    homepage = "https://netfilter.org/projects/libnetfilter_conntrack/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
