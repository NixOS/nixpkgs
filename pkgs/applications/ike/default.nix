{ stdenv, fetchurl, cmake, openssl, libedit, flex, bison, qt4, makeWrapper, gcc }:

# NOTE: use $out/etc/iked.conf as sample configuration and also set: dhcp_file "/etc/iked.dhcp";
# launch with "iked -f /etc/iked.conf"

stdenv.mkDerivation rec {
  name = "ike-2.2.1";

  src = fetchurl {
    url = "https://www.shrew.net/download/ike/${name}-release.tgz";
    sha256 = "0fhyr2psd93b0zf7yfb72q3nqnh65mymgq5jpjcsj9jv5kfr6l8y";
  };

  buildInputs = [ cmake openssl libedit flex bison qt4 makeWrapper ];

  configurePhase = ''
    mkdir -p $out/{bin,sbin,lib}
    cmake -DQTGUI=YES -DETCDIR=$out/etc -DLIBDIR=$out/lib -DSBINDIR=$out/sbin -DBINDIR=$out/bin -DMANDIR=$out/man -DNATT=YES -DCMAKE_INSTALL_PREFIX:BOOL=$out
  '';

  buildPhase = ''
    make
  '';

  installPhase = ''
    make install
    for file in "$out"/bin/* "$out"/sbin/*; do
        wrapProgram $file --prefix LD_LIBRARY_PATH ":" "$out/lib:${openssl}/lib:${gcc.gcc}/lib:${libedit}/lib:${qt4}/lib"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://www.shrew.net/software;
    description = "IPsec Client for FreeBSD, NetBSD and many Linux based operating systems";
    platforms = platforms.unix;
    maintainers = [ maintainers.iElectric ];
    license = "sleepycat";
  };
}
