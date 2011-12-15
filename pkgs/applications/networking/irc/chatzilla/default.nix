{ stdenv, fetchurl, unzip, xulrunner, makeWrapper }:

stdenv.mkDerivation rec {
  name = "chatzilla-0.9.87";
  
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = http://chatzilla.rdmsoft.com/xulrunner/download/chatzilla-0.9.87-xr.zip;
    sha256 = "1qwbqngrxyip3k2b71adg271sifvrrxcixkyrsy4vmgl5bwdsl4d";
  };

  buildInputs = [ unzip makeWrapper ];

  buildCommand = ''
    mkdir -p $out/libexec/chatzilla
    unzip $src -d $out/libexec/chatzilla

    makeWrapper ${xulrunner}/bin/xulrunner $out/bin/chatzilla \
      --add-flags $out/libexec/chatzilla/application.ini
  '';

  meta = {
    homepage = http://chatzilla.hacksrus.com/;
    description = "Stand-alone version of Chatzilla, an IRC client";
  };
}
