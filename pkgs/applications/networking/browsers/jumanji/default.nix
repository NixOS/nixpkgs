{ stdenv, fetchgit, pkgconfig, girara, gtk, webkitgtk, glib_networking, makeWrapper
, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {
  name = "jumanji-${version}";
  version = "20150107";

  src = fetchgit {
    url = https://git.pwmt.org/pwmt/jumanji.git;
    rev = "f8e04e5b5a9fec47d49ca63a096e5d35be281151";
    sha256 = "1dsbyz489fx7dp07i29q1rjkl7nhrfscc8ks8an2rdyhx3457asg";
  };

  buildInputs = [ girara pkgconfig gtk webkitgtk makeWrapper gsettings_desktop_schemas ];

  makeFlags = [ "PREFIX=$(out)" ];

  preFixup=''
    wrapProgram "$out/bin/jumanji" \
     --prefix GIO_EXTRA_MODULES : "${glib_networking.out}/lib/gio/modules" \
     --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Minimal web browser";
    homepage = http://pwmt.org/projects/jumanji/;
    platforms = platforms.all;
    maintainers = [ maintainers.koral ];
  };
}
