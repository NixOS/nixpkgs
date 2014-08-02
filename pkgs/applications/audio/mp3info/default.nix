{ fetchurl, stdenv, ncurses, pkgconfig, gtk }:

stdenv.mkDerivation rec {
  name = "mp3info-0.8.5a";

  src = fetchurl {
    url = "ftp://ftp.ibiblio.org/pub/linux/apps/sound/mp3-utils/mp3info/${name}.tgz";
    sha256 = "042f1czcs9n2sbqvg4rsvfwlqib2gk976mfa2kxlfjghx5laqf04";
  };

  buildInputs = [ ncurses pkgconfig gtk ];

  configurePhase =
    '' sed -i Makefile \
           -e "s|^prefix=.*$|prefix=$out|g ;
               s|/bin/rm|rm|g ;
               s|/usr/bin/install|install|g"
    '';

  preInstall =
    '' mkdir -p "$out/bin"
       mkdir -p "$out/man/man1"
    '';

  meta = {
    description = "MP3Info, an MP3 technical info viewer and ID3 1.x tag editor";

    longDescription =
      '' MP3Info is a little utility used to read and modify the ID3 tags of
         MP3 files.  MP3Info can also display various techincal aspects of an
         MP3 file including playing time, bit-rate, sampling frequency and
         other attributes in a pre-defined or user-specifiable output format.
      '';

    homepage = http://www.ibiblio.org/mp3info/;

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.unix;
  };
}
