{ stdenv, fetchgit, pkgconfig, girara, gtk, webkitgtk, glib-networking, makeWrapper
, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "jumanji-${version}";
  version = "20150107";

  src = fetchgit {
    url = https://git.pwmt.org/pwmt/jumanji.git;
    rev = "f8e04e5b5a9fec47d49ca63a096e5d35be281151";
    sha256 = "1dsbyz489fx7dp07i29q1rjkl7nhrfscc8ks8an2rdyhx3457asg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ girara gtk webkitgtk makeWrapper gsettings-desktop-schemas ];

  makeFlags = [ "PREFIX=$(out)" ];

  preFixup=''
    wrapProgram "$out/bin/jumanji" \
     --prefix GIO_EXTRA_MODULES : "${glib-networking.out}/lib/gio/modules" \
     --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Minimal web browser";
    homepage = https://pwmt.org/projects/jumanji/;
    platforms = platforms.all;
    maintainers = [ maintainers.koral ];
  };
}
