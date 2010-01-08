{ stdenv, fetchurl, Xaw3d, ghostscriptX }:

stdenv.mkDerivation rec {
  name = "gv-3.6.8";

  src = fetchurl {
    url = "mirror://gnu/gv/${name}.tar.gz";
    sha256 = "1i86a4wfswp908gp4i0f6jbksn8bqqzkfy58r9ishspzkp2fb510";
  };

  buildInputs = [ Xaw3d ghostscriptX ];

  patchPhase = ''
    sed 's|\<gs\>|${ghostscriptX}/bin/gs|g' -i "src/"*.in
    sed 's|"gs"|"${ghostscriptX}/bin/gs"|g' -i "src/"*.c
  '';

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/gv/;
    description = "GNU gv, a PostScript/PDF document viewer";

    longDescription = ''
      GNU gv allows users to view and navigate through PostScript and
      PDF documents on an X display by providing a graphical user
      interface for the Ghostscript interpreter.
    '';

    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
