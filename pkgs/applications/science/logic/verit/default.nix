{ stdenv, fetchurl, autoreconfHook, gmp, flex, bison }:

stdenv.mkDerivation rec {
  name = "veriT-${version}";
  version = "201506";

  src = fetchurl {
    url = "http://www.verit-solver.org/distrib/${name}.tar.gz";
    sha256 = "1cc9gcspw3namkdfypkians2j5dn224dsw6xx95qicad6033bsgk";
  };

  nativeBuildInputs = [ autoreconfHook flex bison ];
  buildInputs = [ gmp ];

  makeFlags = [ "LEX=${flex}/bin/flex" ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with stdenv.lib; {
    description = "An open, trustable and efficient SMT-solver";
    homepage = http://www.verit-solver.org/;
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.gebner ];
  };
}
