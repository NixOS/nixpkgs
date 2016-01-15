{ stdenv, fetchurl, unzip, firefox-unwrapped, makeWrapper }:

stdenv.mkDerivation rec {
  name = "chatzilla-0.9.91";

  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = "http://chatzilla.rdmsoft.com/xulrunner/download/${name}.en-US.xulapp";
    sha256 = "1bmjw2wvp8gh7fdl8czkxc55iari6dy672446hps20xixrh8hl8r";
  };

  buildInputs = [ unzip makeWrapper ];

  buildCommand = ''
    mkdir -p $out/libexec/chatzilla
    unzip $src -d $out/libexec/chatzilla

    makeWrapper ${firefox-unwrapped}/bin/firefox $out/bin/chatzilla \
      --add-flags "-app $out/libexec/chatzilla/application.ini"

    sed -i $out/libexec/chatzilla/application.ini -e 's/.*MaxVersion.*/MaxVersion=99.*/'
  '';

  meta = {
    homepage = http://chatzilla.hacksrus.com/;
    description = "Stand-alone version of Chatzilla, an IRC client";
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
