{ lib, stdenv, fetchurl, pkg-config, libpcap, pcre, libnl, zlib, libmicrohttpd
, sqlite, protobuf, protobufc, libusb1, libcap, binutils, elfutils
, withNetworkManager ? false, glib, networkmanager
, withPython ? false, python3
, withSensors ? false, lm_sensors}:

# couldn't get python modules to build correctly,
# waiting for some other volunteer to fix it
assert !withPython;

stdenv.mkDerivation rec {
  pname = "kismet";
  version = "2020-09-R2";

  src = fetchurl {
    url = "https://www.kismetwireless.net/code/${pname}-${version}.tar.xz";
    sha256 = "1n6y6sgqf50bng8n0mhs2r1w0ak14mv654sqay72a78wh2s7ywzg";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libpcap pcre libmicrohttpd libnl zlib sqlite protobuf protobufc
    libusb1 libcap binutils elfutils
  ] ++ lib.optionals withNetworkManager [ networkmanager glib ]
    ++ lib.optional withSensors lm_sensors
    ++ lib.optional withPython (python3.withPackages(ps: [ ps.setuptools ps.protobuf
                                                                  ps.numpy ps.pyserial ]));

  configureFlags = []
    ++ lib.optional (!withNetworkManager) "--disable-libnm"
    ++ lib.optional (!withPython) "--disable-python-tools"
    ++ lib.optional (!withSensors) "--disable-lmsensors";

  postConfigure = ''
    sed -e 's/-o $(INSTUSR)//' \
        -e 's/-g $(INSTGRP)//' \
        -e 's/-g $(MANGRP)//' \
        -e 's/-g $(SUIDGROUP)//' \
        -i Makefile
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Wireless network sniffer";
    homepage = "https://www.kismetwireless.net/";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
