{ stdenv, fetchurl, Xaw3d, ghostscriptX, perl, pkgconfig, libiconv }:

let
  name = "gv-3.7.4";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://gnu/gv/${name}.tar.gz";
    sha256 = "0q8s43z14vxm41pfa8s5h9kyyzk1fkwjhkiwbf2x70alm6rv6qi1";
  };

  configureFlags = stdenv.lib.optionals stdenv.isDarwin [
    "--enable-SIGCHLD-fallback"
  ];

  buildInputs = [
    Xaw3d
    ghostscriptX
    perl
    pkgconfig
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    libiconv
  ];

  patchPhase = ''
    sed 's|\<gs\>|${ghostscriptX}/bin/gs|g' -i "src/"*.in
    sed 's|"gs"|"${ghostscriptX}/bin/gs"|g' -i "src/"*.c
  '';

  doCheck = true;

  meta = {
    homepage = https://www.gnu.org/software/gv/;
    description = "PostScript/PDF document viewer";

    longDescription = ''
      GNU gv allows users to view and navigate through PostScript and
      PDF documents on an X display by providing a graphical user
      interface for the Ghostscript interpreter.
    '';

    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.unix;
  };
}
