{ lib, stdenv, fetchurl, fetchpatch, cmake, openssl, libedit, flex, bison, qt4, makeWrapper
, gcc, nettools, iproute2, linuxHeaders }:

# NOTE: use $out/etc/iked.conf as sample configuration and also set: dhcp_file "/etc/iked.dhcp";
# launch with "iked -f /etc/iked.conf"

# NOTE: my testings reveal that kernels 3.11.10 and 3.12.6 won't let the traffic through the tunnel,
# so I'm sticking with 3.4

stdenv.mkDerivation rec {
  pname = "ike";
  version = "2.2.1";

  src = fetchurl {
    url = "https://www.shrew.net/download/ike/${pname}-${version}-release.tgz";
    sha256 = "0fhyr2psd93b0zf7yfb72q3nqnh65mymgq5jpjcsj9jv5kfr6l8y";
  };

  patches = [
    # required for openssl 1.1.x compatibility
    (fetchpatch {
      name = "openssl-1.1.0.patch";
      url = "https://aur.archlinux.org/cgit/aur.git/plain/openssl-1.1.0.patch?h=ike&id=3a56735ddc26f750df4720f4baba0728bb4cb458";
      sha256 = "1hw8q4xy858rivpjkq5288q3mc75d52bg4w3n30y99h05wik0h51";
    })
  ];

  nativeBuildInputs = [ cmake flex bison makeWrapper ];
  buildInputs = [ openssl libedit qt4 nettools iproute2 ];

  postPatch = ''
    # fix build with bison3
    sed -i 's/define "parser_class_name"/define parser_class_name/' source/iked/conf.parse.yy
  '';

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
        wrapProgram $file --prefix LD_LIBRARY_PATH ":" "$out/lib:${lib.makeLibraryPath [ openssl gcc.cc stdenv.cc.libc libedit qt4 ]}"
    done
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    homepage = "https://www.shrew.net/software";
    description = "IPsec Client for FreeBSD, NetBSD and many Linux based operating systems";
    platforms = platforms.unix;
    maintainers = [ ];
    license = licenses.sleepycat;
  };
}
