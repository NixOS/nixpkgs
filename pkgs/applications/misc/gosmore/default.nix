{ stdenv, fetchsvn, libxml2, gtk, curl, pkgconfig } :

let
  version = "30811";
in
stdenv.mkDerivation {
  name = "gosmore-r${version}";
  src = fetchsvn {
    url = http://svn.openstreetmap.org/applications/rendering/gosmore;
    sha256 = "0qyvrb4xgy4msc7f65widzkvjzc8mlddc4dyr1i76b7wd3gpk0xj";
    rev = "${version}";
  };

  buildInputs = [ libxml2 gtk curl ];

  nativeBuildInputs = [ pkgconfig ];

  prePatch = ''
    sed -e '/curl.types.h/d' -i *.{c,h,hpp,cpp}
  '';
      
  meta = with stdenv.lib; {
    description = "Open Street Map viewer";
    homepage = http://sourceforge.net/projects/gosmore/;
    maintainers = with maintainers; [
      raskin
    ];
    platforms = platforms.linux;
  };
}
