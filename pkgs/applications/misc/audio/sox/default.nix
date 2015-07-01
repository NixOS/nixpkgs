{ lib, stdenv, fetchurl
, enableAlsa ? true, alsaLib ? null
, enableLibao ? true, libao ? null
, enableLame ? false, lame ? null
, enableLibmad ? true, libmad ? null
, enableLibogg ? true, libogg ? null, libvorbis ? null
, enableFLAC ? true, flac ? null
, enablePNG ? true, libpng ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "sox-14.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/sox/${name}.tar.gz";
    sha256 = "16x8gykfjdhxg0kdxwzcwgwpm5caa08y2mx18siqsq0ywmpjr34s";
  };

  patches = [
    # Patches for CVE-2014-8145, found via RedHat bug 1174792.  It was not
    # clear whether these address a NULL deref and a division by zero.
    ./0001-Check-for-minimum-size-sphere-headers.patch
    ./0002-More-checks-for-invalid-MS-ADPCM-blocks.patch
  ];

  buildInputs =
    optional (enableAlsa && stdenv.isLinux) alsaLib ++
    optional enableLibao libao ++
    optional enableLame lame ++
    optional enableLibmad libmad ++
    optionals enableLibogg [ libogg libvorbis ] ++
    optional enableFLAC flac ++
    optional enablePNG libpng;

  meta = {
    description = "Sample Rate Converter for audio";
    homepage = http://sox.sourceforge.net/;
    maintainers = [ lib.maintainers.marcweber ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
