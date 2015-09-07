{ stdenv, fetchurl, pkgconfig
, autoreconfHook, gettext, expat
, confuse, vte, gtk
, makeWrapper }:

stdenv.mkDerivation rec {

  name = "tilda-${version}";
  version = "1.2.2";

  src = fetchurl {
    url = "https://github.com/lanoxx/tilda/archive/${name}.tar.gz";
    sha256 = "1mzly0llsrxpc2yd1hml3gmwm023my2j3aszjw383pp34dab2nl5";
  };

  buildInputs = [ pkgconfig autoreconfHook gettext confuse vte gtk makeWrapper ];

  LD_LIBRARY_PATH = "${expat}/lib"; # ugly hack for xgettext to work during build

  # The config locking scheme relies on the binary being called "tilda",
  # (`pgrep -C tilda`), so a simple `wrapProgram` won't suffice:
  postInstall = ''
    mkdir $out/bin/wrapped
    mv "$out/bin/tilda" "$out/bin/wrapped/tilda"
    makeWrapper "$out/bin/wrapped/tilda" "$out/bin/tilda" \
        --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "A Gtk based drop down terminal for Linux and Unix";
    homepage = https://github.com/lanoxx/tilda/;
    license = licenses.gpl3;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}

