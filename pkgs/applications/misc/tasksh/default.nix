{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "tasksh-${version}";
  version = "1.0.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://taskwarrior.org/download/tasksh-latest.tar.gz";
    sha256 = "0ll6pwhw4wsdffacsmpq46fqh084p9mdaa777giqbag3b8gwik4s";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "REPL for taskwarrior";
    homepage = http://tasktools.org;
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}
