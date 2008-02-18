args: with args;
stdenv.mkDerivation (rec {
  pname = "nano";
  version = "2.0.7";

  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnu/nano/${name}.tar.gz";
    sha256 = "5dc783c412c4d1ff463c450d2a2f9e1ea53a43d9ba1dda92bbf5182f60db532f";
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
    homepage = http://www.nano-editor.org;
  };
})
