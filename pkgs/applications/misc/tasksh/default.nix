{ stdenv, fetchurl, cmake, libuuid, gnutls }:

stdenv.mkDerivation rec {
  name = "tasksh-${version}";
  version = "1.1.0";

  enableParallelBuilding = true;

  src = fetchurl {
    url = "http://taskwarrior.org/download/${name}.tar.gz";
    sha256 = "0900nzfgvhcc106pl68d0v0qszvdc34yi59mw70b34b2gmkwdxzf";
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
