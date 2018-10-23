{ stdenv, fetchurl, qmake, bison, flex }:

stdenv.mkDerivation rec {
  name = "tikzit-${version}";
  version = "2.0";

  src = fetchurl {
    url = "https://github.com/tikzit/tikzit/archive/v${version}.tar.gz";
    sha256 = "15gjnkm4nzm49bmmsfs4xs24vknr7i16fwi1830rh8mcp0qlba6i";
  };

  nativeBuildInputs = [ qmake bison flex ];

  meta = with stdenv.lib; {
    description = "TikZiT is a graphical tool for rapidly creating graphs and string diagrams using PGF/TikZ";
    longDescription = ''
      TikZiT is a super simple GUI editor for graphs and string diagrams. Its
      native file format is a subset of PGF/TikZ, which means TikZiT files can
      be included directly in papers typeset using LaTeX.
    '';
    homepage = https://tikzit.github.io/;
    license = licenses.gpl3;
    maintainers = [ maintainers.nickhu ];
    platforms = platforms.all;
  };
}
