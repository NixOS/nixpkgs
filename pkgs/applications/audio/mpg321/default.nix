{stdenv, fetchurl, libao, libmad, libid3tag, zlib, alsaLib}:

stdenv.mkDerivation rec {
  name = "mpg321-${version}";
  version = "0.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/mpg321/${version}/mpg321_${version}.orig.tar.gz";
    sha256 = "0ki8mh76bbmdh77qsiw682dvi8y468yhbdabqwg05igmwc1wqvq5";
  };

  hardeningDisable = [ "format" ];

  configureFlags = [
    ("--enable-alsa=" + (if stdenv.isLinux then "yes" else "no"))
  ];

  buildInputs = [libao libid3tag libmad zlib]
    ++ stdenv.lib.optional stdenv.isLinux alsaLib;

  installTargets = "install install-man";

  meta = with stdenv.lib; {
    description = "Command-line MP3 player";
    homepage = http://mpg321.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.gnu;
  };
}
