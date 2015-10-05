{ stdenv, fetchurl, autoreconfHook, gettext, texinfo, ncurses, readline }:

stdenv.mkDerivation {
  name = "pinfo-0.6.10";

  src = fetchurl {
    # homepage needed you to login to download the tarball
    url = "http://pkgs.fedoraproject.org/repo/pkgs/pinfo/pinfo-0.6.10.tar.bz2"
      + "/fe3d3da50371b1773dfe29bf870dbc5b/pinfo-0.6.10.tar.bz2";
    sha256 = "0p8wyrpz9npjcbx6c973jspm4c3xz4zxx939nngbq49xqah8088j";
  };

  buildInputs = [ autoreconfHook gettext texinfo ncurses readline ];

  configureFlags = [ "--with-curses=${ncurses.dev}" "--with-readline=${readline}" ];

  meta = with stdenv.lib; {
    description = "A viewer for info files";
    homepage = https://alioth.debian.org/projects/pinfo/;
    license = licenses.gpl2Plus;
  };
}

