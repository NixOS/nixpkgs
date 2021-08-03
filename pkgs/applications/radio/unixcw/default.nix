{ lib, mkDerivation, fetchurl, libpulseaudio, alsa-lib , pkg-config, qtbase }:

mkDerivation rec {
  pname = "unixcw";
  version = "3.5.1";
  src = fetchurl {
    url = "mirror://sourceforge/unixcw/unixcw_${version}.orig.tar.gz";
    sha256 ="5f3aacd8a26e16e6eff437c7ae1e9b389956fb137eeb3de24670ce05de479e7a";
  };
  patches = [
    ./remove-use-of-dlopen.patch
  ];
  buildInputs = [ libpulseaudio alsa-lib pkg-config qtbase ];
  CFLAGS   ="-lasound -lpulse-simple";

  meta = with lib; {
    description = "sound characters as Morse code on the soundcard or console speaker";
    longDescription = ''
       unixcw is a project providing libcw library and a set of programs
       using the library: cw, cwgen, cwcp and xcwcp.
       The programs are intended for people who want to learn receiving
       and sending Morse code.
       unixcw is developed and tested primarily on GNU/Linux system.

       cw  reads  characters  from  an input file, or from standard input,
       and sounds each valid character as Morse code on either the system sound card,
       or the system console speaker.
       After it sounds a  character, cw  echoes it to standard output.
       The input stream can contain embedded command strings.
       These change the parameters used when sounding the Morse code.
       cw reports any errors in  embedded  commands
     '';
    homepage = "http://unixcw.sourceforge.net";
    maintainers = [ maintainers.mafo ];
    license = licenses.gpl2;
    platforms=platforms.linux;
  };
}
