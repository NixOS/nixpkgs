{ stdenv, fetchurl, pidgin, xosd
, autoreconfHook } :

stdenv.mkDerivation rec {
  name = "pidgin-osd-0.2.0";
  src = fetchurl {
    url = https://github.com/edanaher/pidgin-osd/archive/pidgin-osd-0.2.0.tar.gz;
    sha256 = "1dfb0957wwm5zly4w4g815svhkhvjbj3dgik1lbyac8adh9ks784";
  };

  # autoreconf is run such that it *really* wants all the files, and there's no
  # default ChangeLog.  So make it happy.
  preAutoreconf = "touch ChangeLog";

  postInstall = ''
    mkdir -p $out/lib/pidgin
    mv $out/lib/pidgin-osd.{la,so} $out/lib/pidgin
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
