{ stdenv, fetchurl, ladspaH
}:

stdenv.mkDerivation rec {
  name = "AMB-plugins-${version}";
  version = "0.8.1";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${name}.tar.bz2";
    sha256 = "0x4blm4visjqj0ndqr0cg776v3b7lvplpc8cgi9n51llhavn0jpl";
  };

  buildInputs = [ ladspaH ];

  patchPhase = ''
    sed -i 's@/usr/bin/install@install@g' Makefile
    sed -i 's@/bin/rm@rm@g' Makefile
    sed -i 's@/usr/lib/ladspa@$(out)/lib/ladspa@g' Makefile
  '';

  preInstall="mkdir -p $out/lib/ladspa";

  meta = {
    description = ''A set of ambisonics ladspa plugins'';
    longDescription = ''
      Mono and stereo to B-format panning, horizontal rotator, square, hexagon and cube decoders.
    '';
    version = "${version}";
    homepage = http://kokkinizita.linuxaudio.org/linuxaudio/ladspa/index.html;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.magnetophon ];
    platforms = stdenv.lib.platforms.linux;
  };
}
