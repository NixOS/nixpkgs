{ stdenv, fetchsvn, libxml2, gtk, curl, pkgconfig } :

let
  version = "30811";
in
stdenv.mkDerivation {
  name = "gosmore-r${version}";
  src = fetchsvn {
    url = http://svn.openstreetmap.org/applications/rendering/gosmore;
    sha256 = "0d8ddfa0nhz51ambwj9y5jjbizl9y9w44sviisk3ysqvn8q0phds";
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
