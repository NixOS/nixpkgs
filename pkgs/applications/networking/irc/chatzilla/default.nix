{ stdenv, fetchurl, unzip, xulrunner, makeWrapper }:

stdenv.mkDerivation rec {
  name = "chatzilla-0.9.88";
  
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = "http://chatzilla.rdmsoft.com/xulrunner/download/${name}-xr.zip";
    sha256 = "041jpjl7wnbhqm2f8bf2pwp6igjapmy74swac94h54n644wl5nz0";
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
