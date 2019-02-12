{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "bvi-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/bvi/${name}.src.tar.gz";
    sha256 = "00pq9rv7s8inqxq2m3xshxi58691i3pxw9smibcrgh6768l3qnh1";
  };

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    description = "Hex editor with vim style keybindings";
    homepage = http://bvi.sourceforge.net/download.html;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    platforms = with platforms; linux ++ darwin;
  };
}
