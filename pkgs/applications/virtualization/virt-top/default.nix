{ stdenv, fetchgit, ocamlPackages, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "virt-top";
  version = "1.0.9";

  src = fetchgit {
    url = "git://git.annexia.org/virt-top.git";
    rev = "v${version}";
    sha256 = "0m7pm8lzlpngsj0vjv0hg8l9ck3gvwpva7r472f8f03xpjffwiga";
  };

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = with ocamlPackages; [ ocaml findlib ocaml_extlib ocaml_libvirt gettext-stub curses csv xml-light ];

  buildPhase = "make opt";

  meta = with stdenv.lib; {
    description = "A top-like utility for showing stats of virtualized domains";
    homepage = "https://people.redhat.com/~rjones/virt-top/";
    license = licenses.gpl2;
    maintainers = [ maintainers.volth ];
    platforms = platforms.linux;
  };
}
