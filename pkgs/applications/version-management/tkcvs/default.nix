{stdenv, fetchurl, tcl, tk}:

stdenv.mkDerivation
{
  name = "tkcvs-8.2";

  src = fetchurl {
    url = mirror://sourceforge/tkcvs/tkcvs_8_2.tar.gz;
    sha256 = "0cr2f8jd6k2h1n8mvfv6frrfv4kxd7k3mhplk3ghl6hrgklr7ywr";
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
    license = "GPLv2+";
  };
}
