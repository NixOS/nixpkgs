{ fetchurl, stdenv, libxml2, freetype, mesa, glew, qt
, autoconf, automake, libtool, cmake, makeWrapper }:

let version = "3.5.0"; in
stdenv.mkDerivation rec {
  name = "tulip-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/auber/tulip/tulip-${version}/${name}-src.tar.gz";
    sha256 = "0wl0wqjlifpay61pn7dxr3dl5r4a7v80f5g277p6s06ibvn2p3ln";
  };

  buildInputs = [ libxml2 freetype glew ]
    ++ [ autoconf automake libtool cmake qt makeWrapper ];
  propagagedBuildInputs = [ mesa qt ];

  postInstall=''
    wrapProgram "$out/bin/tulip"
  '';

  # FIXME: "make check" needs Docbook's DTD 4.4, among other things.
  doCheck = false;

  meta = {
    description = "Tulip, a visualization framework for the analysis and visualization of relational data";

    longDescription =
      '' Tulip is an information visualization framework dedicated to the
         analysis and visualization of relational data.  Tulip aims to
         provide the developer with a complete library, supporting the design
         of interactive information visualization applications for relational
         data that can be tailored to the problems he or she is addressing.
      '';

    homepage = http://tulip.labri.fr/;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
