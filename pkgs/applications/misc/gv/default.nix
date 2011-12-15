{ stdenv, fetchurl, Xaw3d, ghostscriptX, perl }:

let
  name = "gv-3.7.3";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/gv/${name}.tar.gz";
    sha256 = "ee01ba96e3a5c319eb4658357372a118dbb0e231891b360edecbdebd449d1c2b";
  };

  buildInputs = [ Xaw3d ghostscriptX perl ];

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
