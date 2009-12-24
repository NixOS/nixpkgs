args: with args;
stdenv.mkDerivation (rec {
  pname = "nano";
  version = "2.2.1";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.gz";
    sha256 = "1xqldl7ipsmz5x8q3fw9s6yshxfp39kly96kb15l1kawng1wfcfq";
  };
  buildInputs = [ncurses gettext];
#  configureFlags = "--enable-tiny";
  configureFlags = "
    --disable-browser 
    --disable-help 
    --disable-justify 
    --disable-mouse 
    --disable-operatingdir
    --disable-speller
    --disable-tabcomp
    --disable-wrapping
  ";

  meta = {
    homepage = http://www.nano-editor.org/;
    description = "A small, user-friendly console text editor";
  };
})
