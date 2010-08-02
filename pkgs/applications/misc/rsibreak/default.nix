{ stdenv, fetchurl, cmake, kdelibs, kdebase_workspace }:

stdenv.mkDerivation rec {
  name = "rsibreak-0.10";

  src = fetchurl {
    url = "http://www.rsibreak.org/files/${name}.tar.bz2";
    sha256 = "02vvwmzhvc9jfrzmnfn3cygx63yx7g360lcslwj1vikzkg834ik0";
  };

  buildInputs = [ cmake kdelibs kdebase_workspace ];
}
