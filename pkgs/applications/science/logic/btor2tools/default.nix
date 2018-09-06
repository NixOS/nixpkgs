{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "btor2tools-${version}";
  version = "pre55_8c150b39";

  src = fetchFromGitHub {
    owner  = "boolector";
    repo   = "btor2tools";
    rev    = "8c150b39cdbcdef4247344acf465d75ef642365d";
    sha256 = "1r5pid4x567nms02ajjrz3v0zj18k0fi5pansrmc2907rnx2acxx";
  };

  configurePhase = "./configure.sh -shared";

  installPhase = ''
    mkdir -p $out $dev/include/btor2parser/ $lib/lib

    cp -vr bin $out
    cp -v  src/btor2parser/btor2parser.h $dev/include/btor2parser
    cp -v  build/libbtor2parser.* $lib/lib
  '';

  outputs = [ "out" "dev" "lib" ];

  meta = with stdenv.lib; {
    description = "Fast SAT solver";
    homepage    = http://fmv.jku.at/lingeling/;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
