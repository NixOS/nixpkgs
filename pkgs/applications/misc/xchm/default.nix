{stdenv, fetchurl, wxGTK, chmlib}:

stdenv.mkDerivation {
  name = "xchm-1.18";
  src = fetchurl {
    url = mirror://sourceforge/xchm/xchm-1.18.tar.gz;
    sha256 = "1wvvyzqbmj3c6i46x4vpxkawjwmmp276r84ifvlzaj5q4b52g5gw";
  };
  buildInputs = [wxGTK chmlib];

  postConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS $(${wxGTK}/lib/wx/config/* --libs | sed -e s@-pthread@@)"
    echo $NIX_LDFLAGS
  '';

  meta = {
    description = "A viewer for Microsoft HTML Help files";
    homepage = http://xchm.sourceforge.net;
  };
}
