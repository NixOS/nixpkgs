{ mkDerivation, stdenv, fetchFromGitHub, fetchpatch, pkg-config, qtscript, qmake, libjack2
}:

mkDerivation rec {
  pname = "jamulus";
  version = "3.5.9";
  src = fetchFromGitHub {
    owner = "corrados";
    repo = "jamulus";
    rev = "r${stdenv.lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "0h2m1sahi8cg15k6wa9m2d38va2cs3nvi0q8rpr9vak8g8d3p460";
  };

  nativeBuildInputs = [ pkg-config qmake ];
  buildInputs = [ qtscript libjack2 ];

  qmakeFlags = [ "CONFIG+=noupcasename" ];

  meta = {
    description = "Enables musicians to perform real-time jam sessions over the internet";
    longDescription = "You also need to enable JACK and should enable several real-time optimizations. See project website for details";
    homepage = "https://github.com/corrados/jamulus/wiki";
    license = stdenv.lib.licenses.gpl2; # linked in git repo, at least
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.seb314 ];
  };
}
