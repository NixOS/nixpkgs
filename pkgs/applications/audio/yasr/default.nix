{stdenv,fetchurl}:

stdenv.mkDerivation rec {
  pname = "yasr";

  version = "0.6.9";

  src = fetchurl {
    url = "https://sourceforge.net/projects/yasr/files/yasr/${version}/${pname}-${version}.tar.gz";
    sha256 = "1prv9r9y6jb5ga5578ldiw507fa414m60xhlvjl29278p3x7rwa1";
  };

  patches = [
    ./10_fix_openpty_forkpty_declarations
    ./20_maxpathlen
    ./30_conf
    ./40_dectalk_extended_chars
  ]; # taken from the debian yasr package

  meta = {
    homepage = "http://yasr.sourceforge.net";
    description = "A general-purpose console screen reader";
    longDescription = "Yasr is a general-purpose console screen reader for GNU/Linux and other Unix-like operating systems.";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ jhhuh ];
  };
}
