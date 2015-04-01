{ stdenv, fetchgit, pkgconfig, girara, gtk, webkitgtk, glib_networking, makeWrapper }:

stdenv.mkDerivation rec {
  name = "jumanji-${version}";
  version = "20140622";

  src = fetchgit {
    url = git://pwmt.org/jumanji.git;
    rev = "8f40487304a6a931487c411b25001f2bb5cf8d4f";
    sha256 = "1hdk09rayyv2knxzn4n7d41dvh34gdk9ra75x7g9n985w13pkinv";
  };

  buildInputs = [ girara pkgconfig gtk webkitgtk makeWrapper ];

  makeFlags = [ "PREFIX=$(out)" ];

  preFixup=''
    wrapProgram "$out/bin/jumanji" \
     --prefix GIO_EXTRA_MODULES : "${glib_networking}/lib/gio/modules"
  '';

  meta = with stdenv.lib; {
    description = "Minimal web browser";
    homepage = http://pwmt.org/projects/jumanji/;
    platforms = platforms.all;
    maintainers = [ maintainers.koral ];
  };
}
