{ stdenv, fetchurl, autoreconfHook, gmp, flex, bison }:

stdenv.mkDerivation rec {
  name = "veriT-${version}";
  version = "2016";

  src = fetchurl {
    url = "http://www.verit-solver.org/distrib/veriT-stable2016.tar.gz";
    sha256 = "0gvp4diz0qjg0y5ry0p1z7dkdkxw8l7jb8cdhvcnhl06jx977v4b";
  };

  nativeBuildInputs = [ autoreconfHook flex bison ];
  buildInputs = [ gmp ];

  # --disable-static actually enables static linking here...
  dontDisableStatic = true;

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
