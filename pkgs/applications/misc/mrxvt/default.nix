args: with args;
stdenv.mkDerivation {

  name = "mrxvt-0.5.3";

  buildInputs = [libX11];

  configureFlags="--with-x";

  src = fetchurl {
    url = mirror://sourceforge/materm/mrxvt-0.5.3.tar.gz;
    sha256 = "04flnn58hp4qvvk6jzyipsj13v1qyrjabgbw5laz5cqxvxzpncp2";
  };

  meta = { 
    description = "multitabbed lightweight terminal emulator basd on rxvt supporting transparency, backgroundimages, freetype fonts,..";
    homepage = http://sourceforge.net/projects/materm;
    license = "GPL";
  };
}
