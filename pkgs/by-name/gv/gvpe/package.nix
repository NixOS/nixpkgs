{
  lib,
  stdenv,
  fetchurl,
  openssl,
  gmp,
  zlib,
  iproute2,
  net-tools,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "gvpe";
  version = "3.1";

  src = fetchurl {
    url = "https://ftp.gnu.org/gnu/gvpe/gvpe-${version}.tar.gz";
    sha256 = "sha256-8evVctclu5QOCAdxocEIZ8NQnc2DFvYRSBRQPcux6LM=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    openssl
    gmp
    zlib
  ];

  configureFlags = [
    "--enable-tcp"
    "--enable-http-proxy"
    "--enable-dns"
  ];

  postPatch = ''
    sed -e 's@"/sbin/ifconfig.*"@"${iproute2}/sbin/ip link set dev $IFNAME address $MAC mtu $MTU"@' -i src/device-linux.C
    sed -e 's@/sbin/ifconfig@${net-tools}/sbin/ifconfig@g' -i src/device-*.C
  '';

  meta = with lib; {
    description = "Protected multinode virtual network";
    homepage = "http://software.schmorp.de/pkg/gvpe.html";
    maintainers = [ maintainers.raskin ];
    platforms = with platforms; linux ++ freebsd;
    license = licenses.gpl2Plus;
  };
}
