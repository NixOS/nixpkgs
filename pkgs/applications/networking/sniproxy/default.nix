{ stdenv, fetchFromGitHub, autoconf, automake, autoreconfHook, gettext, libev, pcre, pkgconfig, udns }:

stdenv.mkDerivation rec {
  name = "sniproxy-${version}";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "dlundquist";
    repo = "sniproxy";
    rev = version;
    sha256 = "1r6hv55k2z8l5q57l2q2x3nsspc2yjvi56l760yrz2c1hgh6r0a2";
  };

  buildInputs = [ autoconf automake autoreconfHook gettext libev pcre pkgconfig udns ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Transparent TLS and HTTP layer 4 proxy with SNI support";
    license = licenses.bsd2;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.linux;
  };

}
