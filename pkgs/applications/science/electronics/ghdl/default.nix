{stdenv, fetchurl, gnat}:
stdenv.mkDerivation rec {
  name = "ghdl-0.28";

  src = fetchurl {
    url = "http://ghdl.free.fr/${name}.tar.bz2";
    sha256 = "0l3ah3zw2yhr9rv9d5ck1cinsf11r28m6bzl2sdibngl2bgc2jsf";
  };

  buildInputs = [ gnat ];

  meta = {
      description = "Complete VHDL simulator, using the GCC technology";
      homepage = http://ghdl.free.fr/;
      # There is a mixture of licenses per file
      license = "free";
  };
}
