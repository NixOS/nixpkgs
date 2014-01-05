{ stdenv, fetchurl, ncurses, gettext }:

stdenv.mkDerivation (rec {
  pname = "nano";
  version = "2.3.2";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.gz";
    sha256 = "1s3b21h5p7r8xafw0gahswj16ai6k2vnjhmd15b491hl0x494c7z";
  };

  buildInputs = [ ncurses gettext ];

  meta = {
    homepage = http://www.nano-editor.org/;
    description = "A small, user-friendly console text editor";
  };
})
