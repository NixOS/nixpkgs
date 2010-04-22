args: with args;
stdenv.mkDerivation (rec {
  pname = "nano";
  version = "2.2.3";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.gz";
    sha256 = "1vpl993xrpj8bqi1ayga8fc0j2jag90xp6rqakzwm3bxw71hmwi2";
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
