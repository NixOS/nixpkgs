{ stdenv, fetchurl, pidgin, xosd
, autoconf, automake, libtool } :

stdenv.mkDerivation rec {
  name = "pidgin-osd-0.1.0";
  src = fetchurl {
    url = https://github.com/mbroemme/pidgin-osd/archive/pidgin-osd-0.1.0.tar.gz;
    sha256 = "11hqfifhxa9gijbnp9kq85k37hvr36spdd79cj9bkkvw4kyrdp3j";
  };

  preConfigure = "./autogen.sh";

  makeFlags = "PIDGIN_LIBDIR=$(out)";

  postInstall = ''
    mkdir -p $out/lib/pidgin
    ln -s $out/pidgin $out/lib/pidgin
  '';

  buildInputs = [ xosd pidgin autoconf automake libtool ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mbroemme/pidgin-osd;
    description = "Plugin for Pidgin which implements on-screen display via libxosd";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
