{ stdenv, fetchurl, unzip, firefox-unwrapped, makeWrapper }:

stdenv.mkDerivation rec {
  name = "chatzilla-0.9.92";

  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = "http://chatzilla.rdmsoft.com/xulrunner/download/${name}.en-US.xulapp";
    sha256 = "09asg7ixjrin46xd19ri71g4jdrgb1gg0pk0lwk0dlb1qjxyf1xy";
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
