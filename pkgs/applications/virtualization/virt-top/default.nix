{ stdenv, fetchurl, ocamlPackages }:

stdenv.mkDerivation rec {
  name = "virt-top-${version}";
  version = "1.0.8";

  src = fetchurl {
    url = "https://people.redhat.com/~rjones/virt-top/files/virt-top-${version}.tar.gz";
    sha256 = "04i1sf2d3ghilmzvr2vh74qcy009iifyc2ymj9kxnbkp97lrz13w";
  };

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
