{ lib, stdenv, fetchurl
, enableAlsa ? true, alsaLib ? null
, enableLibao ? true, libao ? null
, enableLame ? false, lame ? null
, enableLibmad ? true, libmad ? null
, enableLibogg ? true, libogg ? null, libvorbis ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "sox-14.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/sox/${name}.tar.gz";
    sha256 = "16x8gykfjdhxg0kdxwzcwgwpm5caa08y2mx18siqsq0ywmpjr34s";
  };

  buildInputs =
    optional (enableAlsa && stdenv.isLinux) alsaLib ++
    optional enableLibao libao ++
    optional enableLame lame ++
    optional enableLibmad libmad ++
    optionals enableLibogg [ libogg libvorbis ];

  meta = {
    description = "Sample Rate Converter for audio";
    homepage = http://www.mega-nerd.com/SRC/index.html;
    maintainers = [ lib.maintainers.marcweber lib.maintainers.shlevy ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
