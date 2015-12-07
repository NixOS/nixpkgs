{ stdenv, fetchsvn, libxml2, gtk, curl, pkgconfig } :

let
  version = "31801";
in
stdenv.mkDerivation {
  name = "gosmore-r${version}";
  src = fetchsvn {
    url = http://svn.openstreetmap.org/applications/rendering/gosmore;
    sha256 = "0i6m3ikavsaqhfy18sykzq0cflw978nr4fhg18hawndcmr45v5zj";
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
