{ stdenv, fetchgit, ocamlPackages, autoreconfHook }:

stdenv.mkDerivation {
  pname = "virt-top";
  version = "2017-11-18-unstable";

  src = fetchgit {
    url = git://git.annexia.org/git/virt-top.git;
    rev = "18a751d8c26548bb090ff05e30ccda3092e3373b";
    sha256 = "0c4whjvw7p3yvd476i4ppdhi8j821r5y6caqrj2v9dc181cnp01i";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = with ocamlPackages; [ ocaml findlib ocaml_extlib ocaml_libvirt ocaml_gettext curses csv xml-light ];

  buildPhase = "make opt";

  meta = with stdenv.lib; {
    description = "A top-like utility for showing stats of virtualized domains";
    homepage = https://people.redhat.com/~rjones/virt-top/;
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = platforms.linux;
  };
}
