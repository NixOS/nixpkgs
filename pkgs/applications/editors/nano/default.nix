{ stdenv, fetchurl, ncurses, gettext }:

stdenv.mkDerivation (rec {
  pname = "nano";
  version = "2.2.6";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.gz";
    sha256 = "0yp6pid67k8h7394spzw0067fl2r7rxm2b6kfccg87g8nlry2s5y";
  };

  buildInputs = [ ncurses gettext ];

  meta = {
    homepage = http://www.nano-editor.org/;
    description = "A small, user-friendly console text editor";
  };
})
