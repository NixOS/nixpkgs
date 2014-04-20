{ stdenv, fetchurl
, enableAlsa ? true, alsaLib ? null
, enableLibao ? true, libao ? null
, enableLame ? false, lame ? null
, enableLibmad ? true, libmad ? null
, enableLibogg ? true, libogg ? null, libvorbis ? null
}:
let
  inherit (stdenv.lib) optional optionals;
in stdenv.mkDerivation rec {
  name = "sox-14.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/sox/${name}.tar.gz";
    sha256 = "16x8gykfjdhxg0kdxwzcwgwpm5caa08y2mx18siqsq0ywmpjr34s";
  };

  buildInputs =
    (optional enableAlsa alsaLib) ++
    (optional enableLibao libao) ++
    (optional enableLame lame) ++
    (optional enableLibmad libmad) ++
    (optionals enableLibogg [ libogg libvorbis ]);

  meta = {
    description = "Sample Rate Converter for audio";
    homepage = http://www.mega-nerd.com/SRC/index.html;
    maintainers = [stdenv.lib.maintainers.marcweber stdenv.lib.maintainers.shlevy];
    # you can choose one of the following licenses:
    license = [
      "GPL"
      # http://www.mega-nerd.com/SRC/libsamplerate-cul.pdf
      "libsamplerate Commercial Use License"
    ];
  };
}
