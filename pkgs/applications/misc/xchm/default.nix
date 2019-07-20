{stdenv, fetchurl, wxGTK, chmlib}:

stdenv.mkDerivation {
  name = "xchm-1.23";
  src = fetchurl {
    url = mirror://sourceforge/xchm/xchm-1.23.tar.gz;
    sha256 = "0qn0fyxcrn30ndq2asx31k0qkx3grbm16fb1y580wd2gjmh5r3wg";
  };
  buildInputs = [wxGTK chmlib];

  postConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS $(${wxGTK}/lib/wx/config/* --libs | sed -e s@-pthread@@)"
    echo $NIX_LDFLAGS
  '';

  meta = with stdenv.lib; {
    description = "A viewer for Microsoft HTML Help files";
    homepage = http://xchm.sourceforge.net;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
