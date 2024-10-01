{ lib, stdenv, fetchurl, ladspaH
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "amb-plugins";
  version = "0.8.1";
  src = fetchurl {
    url = "http://kokkinizita.linuxaudio.org/linuxaudio/downloads/AMB-plugins-${finalAttrs.version}.tar.bz2";
    sha256 = "0x4blm4visjqj0ndqr0cg776v3b7lvplpc8cgi9n51llhavn0jpl";
  };

  buildInputs = [ ladspaH ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail '/usr/bin/install' 'install' \
      --replace-fail '/bin/rm' 'rm' \
      --replace-fail '/usr/lib/ladspa' '$(out)/lib/ladspa' \
      --repalce-fail 'g++' '$(CXX)'
  '';

  preInstall="mkdir -p $out/lib/ladspa";

  meta = {
    description = "Set of ambisonics ladspa plugins";
    longDescription = ''
      Mono and stereo to B-format panning, horizontal rotator, square, hexagon and cube decoders.
    '';
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/ladspa/index.html";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
  };
})
