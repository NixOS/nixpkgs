{ lib, stdenv, fetchgit, fetchpatch, ocamlPackages, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "virt-top";
  version = "1.0.9";

  src = fetchgit {
    url = "git://git.annexia.org/virt-top.git";
    rev = "v${version}";
    sha256 = "0m7pm8lzlpngsj0vjv0hg8l9ck3gvwpva7r472f8f03xpjffwiga";
  };

  patches = [
    (fetchpatch {
      name = "ocaml-libvirt-0.6.1.5-fix.patch";
      url = "http://git.annexia.org/?p=virt-top.git;a=patch;h=24a461715d5bce47f63cb0097606fc336230589f";
      sha256 = "15w7w9iggvlw8m9w8g4h08251wzb3m3zkb58glr7ifsgi3flbn61";
    })
  ];

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = with ocamlPackages; [ ocaml findlib ocaml_extlib ocaml_libvirt gettext-stub curses csv xml-light ];

  buildPhase = "make opt";

  meta = with lib; {
    description = "A top-like utility for showing stats of virtualized domains";
    homepage = "https://people.redhat.com/~rjones/virt-top/";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
