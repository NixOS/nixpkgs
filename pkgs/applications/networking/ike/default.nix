{ stdenv, fetchurl, cmake, openssl, libedit, flex, bison, qt4, makeWrapper
, gcc, nettools, iproute, linuxHeaders }:

assert stdenv.isLinux;

# NOTE: use $out/etc/iked.conf as sample configuration and also set: dhcp_file "/etc/iked.dhcp";
# launch with "iked -f /etc/iked.conf"

# NOTE: my testings reveal that kernels 3.11.10 and 3.12.6 won't let the traffic through the tunnel,
# so I'm sticking with 3.4

stdenv.mkDerivation rec {
  name = "ike-2.2.1";

  src = fetchurl {
    url = "https://www.shrew.net/download/ike/${name}-release.tgz";
    sha256 = "0fhyr2psd93b0zf7yfb72q3nqnh65mymgq5jpjcsj9jv5kfr6l8y";
  };

  buildInputs = [ cmake openssl libedit flex bison qt4 makeWrapper nettools iproute ];

  configurePhase = ''
    mkdir -p $out/{bin,sbin,lib}
    cmake -DQTGUI=YES -DETCDIR=$out/etc -DLIBDIR=$out/lib -DSBINDIR=$out/sbin -DBINDIR=$out/bin \
          -DKRNINC="${linuxHeaders}/include/" -DTESTS=YES \
          -DMANDIR=$out/man -DNATT=YES -DCMAKE_INSTALL_PREFIX:BOOL=$out
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
    for file in "$out"/bin/* "$out"/sbin/*; do
        wrapProgram $file --prefix LD_LIBRARY_PATH ":" "$out/lib:${stdenv.lib.makeLibraryPath [ openssl gcc.cc stdenv.cc.libc libedit qt4 ]}"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://www.shrew.net/software;
    description = "IPsec Client for FreeBSD, NetBSD and many Linux based operating systems";
    platforms = platforms.unix;
    maintainers = [ maintainers.domenkozar ];
    license = licenses.sleepycat;
  };
}
