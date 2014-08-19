{stdenv, fetchurl, perl}: 

stdenv.mkDerivation rec {
  name = "yacas-1.2.2";

  src = fetchurl {
    url = "http://yacas.sourceforge.net/backups/${name}.tar.gz";
    sha256 = "1dmafm3w0lm5w211nwkfzaid1rvvmgskz7k4500pjhgdczi5sd78";
  };

  # Perl is only for the documentation
  nativeBuildInputs = [ perl ];

  patches = [ ./gcc43.patch ];

  crossAttrs = {
    # Trick to get host-built programs needed for the cross-build.
    # If yacas had proper makefiles, this would not be needed.
    preConfigure = ''
      ./configure
      pushd src
      make mkfastprimes 
      cp mkfastprimes ../..
      popd
      pushd manmake
      make manripper removeduplicates
      cp manripper removeduplicates ../..
      popd
    '';
    preBuild = ''
      cp ../mkfastprimes ../manripper ../removeduplicates src
    '';
  };

  meta = { 
      description = "Easy to use, general purpose Computer Algebra System";
      homepage = http://yacas.sourceforge.net/;
      license = stdenv.lib.licenses.gpl2Plus;
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; all;
  };
}
