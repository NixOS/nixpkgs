{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "timewarrior-${version}";
  version = "1.1.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "https://taskwarrior.org/download/timew-${version}.tar.gz";
    sha256 = "0jnwj8lflr6nlch2j2hkmgpdqq3zbdd2sfpi5iwiabljk25v9iq9";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A command-line time tracker";
    homepage = https://tasktools.org/projects/timewarrior.html;
    license = licenses.mit;
    maintainers = with maintainers; [ matthiasbeyer ];
    platforms = platforms.linux;
  };
}

