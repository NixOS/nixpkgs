{stdenv, fetchurl, perl}: 

stdenv.mkDerivation rec {
  name = "yacas-1.2.2";

  src = fetchurl {
    url = "http://yacas.sourceforge.net/backups/${name}.tar.gz";
    sha256 = "1dmafm3w0lm5w211nwkfzaid1rvvmgskz7k4500pjhgdczi5sd78";
  };

  # Perl is only for the documentation
  buildInputs = [ perl ];

  patches = [ ./gcc43.patch ];

  meta = { 
      description = "Easy to use, general purpose Computer Algebra System";
      homepage = http://yacas.sourceforge.net/;
      license = "GPLv2+";
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; all;
  };
}
