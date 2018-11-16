{ fetchurl, stdenv, libXrandr}:

stdenv.mkDerivation rec {
  version = "0.01";
  name = "xrandr-invert-colors-${version}";
  src = fetchurl {
    url = "https://github.com/zoltanp/xrandr-invert-colors/archive/v${version}.tar.gz";
    sha256 = "1z4hxn56rlflvqanb8ncqa1xqawnda85b1b37w6r2iqs8rw52d75";
  };

  buildInputs = [ libXrandr ];

  installPhase = ''
    mkdir -p $out/bin
    mv xrandr-invert-colors.bin xrandr-invert-colors
    install xrandr-invert-colors $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Inverts the colors of your screen";
    license = stdenv.lib.licenses.gpl3Plus;
    homepage = https://github.com/zoltanp/xrandr-invert-colors;
    maintainers = [stdenv.lib.maintainers.magnetophon ];
    platforms = platforms.linux;
  }; 
}
