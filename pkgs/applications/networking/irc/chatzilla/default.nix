{ stdenv, fetchurl, unzip, xulrunner, makeWrapper }:

stdenv.mkDerivation rec {
  name = "chatzilla-0.9.90.1";

  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = "http://chatzilla.rdmsoft.com/xulrunner/download/${name}.en-US.xulapp";
    sha256 = "0z38jig91h10cb14rvs30rpg2pgn3v890nyxyy8lxzbv5ncxmngw";
  };

  buildInputs = [ unzip makeWrapper ];

  buildCommand = ''
    mkdir -p $out/libexec/chatzilla
    unzip $src -d $out/libexec/chatzilla

    makeWrapper ${xulrunner}/bin/xulrunner $out/bin/chatzilla \
      --add-flags $out/libexec/chatzilla/application.ini

    sed -i $out/libexec/chatzilla/application.ini -e 's/.*MaxVersion.*/MaxVersion=99.*/'
  '';

  meta = {
    homepage = http://chatzilla.hacksrus.com/;
    description = "Stand-alone version of Chatzilla, an IRC client";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
