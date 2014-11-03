{ stdenv, fetchurl, emacs }:

stdenv.mkDerivation rec {
  name = "bbdb-3.1.2";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/bbdb/${name}.tar.gz";
    sha256 = "1gs16bbpiiy01w9pyg12868r57kx1v3hnw04gmqsmpc40l1hyy05";
  };

  buildInputs = [ emacs ];

  # Hack to disable documentation as there is no way to tell bbdb to
  # NOT build pdfs. I really don't want to pull in TexLive here...
  preConfigure = ''
   substituteInPlace ./Makefile.in \
     --replace "SUBDIRS = lisp doc tex" "SUBDIRS = lisp"
  '';

  meta = {
    homepage = "http://savannah.nongnu.org/projects/bbdb/";
    description = "The Insidious Big Brother Database (BBDB), a contact management utility for Emacs, version 3";
    license = "GPL";
  };
}
