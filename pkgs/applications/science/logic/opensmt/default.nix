{ stdenv, fetchurl, automake, libtool, autoconf, intltool, perl
, gmpxx, flex, bison
}:

stdenv.mkDerivation rec {
  name = "opensmt-${version}";
  version = "20101017";

  src = fetchurl {
    url = "http://opensmt.googlecode.com/files/opensmt_src_${version}.tgz";
    sha256 = "0xrky7ixjaby5x026v7hn72xh7d401w9jhccxjn0khhn1x87p2w1";
  };

  buildInputs = [ automake libtool autoconf intltool perl gmpxx flex bison ];

  meta = with stdenv.lib; {
    description = "A satisfiability modulo theory (SMT) solver";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl3;
    homepage = http://code.google.com/p/opensmt/;
    broken = true;
    downloadPage = "http://code.google.com/p/opensmt/downloads/list";
  };
}
