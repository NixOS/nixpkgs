{stdenv, fetchurl, tcl, tk}:

stdenv.mkDerivation
{
  name = "tkcvs-8.2.1";

  src = fetchurl {
    url = mirror://sourceforge/tkcvs/tkcvs_8_2_1.tar.gz;
    sha256 = "0kvj6rcx1153wq0n1lmd8imbrki6xy5wxghwzlb9i15l65sclg3i";
  };

  buildInputs = [ tcl tk ];

  patchPhase = ''
    sed -e 's@exec wish@exec ${tk}/bin/wish@' -i tkcvs/tkcvs.tcl tkdiff/tkdiff
  '';

  installPhase = ''
    ./doinstall.tcl $out
  '';

  meta = {
    homepage = http://www.twobarleycorns.net/tkcvs.html;
    description = "TCL/TK GUI for cvs and subversion";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
