{stdenv, fetchurl, libX11, libXinerama, enableXft, libXft, zlib}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dmenu-4.5";

  src = fetchurl {
    url = "http://dl.suckless.org/tools/${name}.tar.gz";
    sha256 = "0l58jpxrr80fmyw5pgw5alm5qry49aw6y049745wl991v2cdcb08";
  };

  xftPatch = fetchurl {
    url = "http://tools.suckless.org/dmenu/patches/${name}-xft.diff";
    sha256 = "efb4095d65e5e86f9dde97294732174409c24f319bdd4824cc22fa1404972b4f";
  };

  buildInputs = [ libX11 libXinerama ] ++ optionals enableXft [zlib libXft];

  patches = optional enableXft xftPatch;

  postPatch = ''
    sed -ri -e 's!\<(dmenu|stest)\>!'"$out/bin"'/&!g' dmenu_run
  '';

  preConfigure = [ ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g" config.mk'' ];

  meta = { 
      description = "a generic, highly customizable, and efficient menu for the X Window System";
      homepage = http://tools.suckless.org/dmenu;
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [viric];
      platforms = with stdenv.lib.platforms; all;
  };
}
