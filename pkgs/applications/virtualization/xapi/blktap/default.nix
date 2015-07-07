{stdenv, fetchurl, autoconf, automake, libaio, libtool, libuuid, openssl, xen}:

stdenv.mkDerivation {
  name = "blktap-0.9.3-pre001";
  version = "0.9.3-pre001";

  src = fetchurl {
    url = "https://github.com/xapi-project/blktap/archive/fe874dbc0a4df6392907c35fcbd345e146eefdd7/blktap-0.9.3.fe874d.tar.gz";
    sha256 = "05n50x48p6qrddk4h9n37ay844zi5almi4a6qc32afmwdzz8yw8m";
  };

  buildInputs = [ autoconf automake libaio libtool libuuid openssl xen ];

  configurePhase = ''
    sh autogen.sh
    ./configure --prefix $out/lib/blktap
    '';

  buildPhase = ''
    make
    '';


  installPhase = ''
    mkdir -p $out/lib/blktap
    mkdir -p $out/lib/blktap/lib
    mkdir -p $out/lib/blktap/sbin
    mkdir -p $out/lib/blktap/bin
    mkdir -p $out/lib/blktap/include/blktap
    mkdir -p $out/lib/blktap/include/vhd
    mkdir -p $out/lib/blktap/libexec
    mkdir -p $out/lib/blktap/etc/udev/rules.d

    make install
    '';

  meta = {
    homepage = https://github.com/xapi-project/blktap;
    description = "Enhanced version of tapdisk";
    license = stdenv.lib.licenses.lgpl2;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
