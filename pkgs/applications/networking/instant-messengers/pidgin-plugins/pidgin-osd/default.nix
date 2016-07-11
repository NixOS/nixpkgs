{ stdenv, fetchurl, pidgin, xosd
, autoreconfHook } :

stdenv.mkDerivation rec {
  name = "pidgin-osd-0.1.0";
  src = fetchurl {
    url = https://github.com/mbroemme/pidgin-osd/archive/pidgin-osd-0.1.0.tar.gz;
    sha256 = "11hqfifhxa9gijbnp9kq85k37hvr36spdd79cj9bkkvw4kyrdp3j";
  };

  makeFlags = "PIDGIN_LIBDIR=$(out)";

  # autoreconf is run such that it *really* wants all the files, and there's no
  # default ChangeLog.  So make it happy.
  preAutoreconf = "touch ChangeLog";

  postInstall = ''
    mkdir -p $out/lib/pidgin
    ln -s $out/pidgin $out/lib/pidgin
  '';

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ xosd pidgin ];

  meta = with stdenv.lib; {
    homepage = https://github.com/mbroemme/pidgin-osd;
    description = "Plugin for Pidgin which implements on-screen display via libxosd";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
