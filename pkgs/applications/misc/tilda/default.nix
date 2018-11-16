{ stdenv, fetchurl, pkgconfig
, autoreconfHook, gettext, expat
, confuse, vte, gtk
, makeWrapper }:

stdenv.mkDerivation rec {

  name = "tilda-${version}";
  version = "1.4.1";

  src = fetchurl {
    url = "https://github.com/lanoxx/tilda/archive/${name}.tar.gz";
    sha256 = "0w2hry2bqcqrkik4l100b1a9jlsih6sq8zwhfpl8zzfq20i00lfs";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ gettext confuse vte gtk makeWrapper ];

  LD_LIBRARY_PATH = "${expat.out}/lib"; # ugly hack for xgettext to work during build

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

