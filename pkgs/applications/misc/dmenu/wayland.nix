{stdenv, fetchurl #, libX11, libXinerama, enableXft, libXft, zlib
, swc, wld, wayland, libxkbcommon, pixman, fontconfig
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dmenu-wayland-${version}";
  version = "git-2017-04-07";
  rev = "f385d9d18813071b4b4257bf8d4d572daeda0e70";

  src = fetchurl {
    url = "https://github.com/michaelforney/dmenu/archive/${rev}.tar.gz";
    sha256 = "0y1jvh2815c005ns0bsjxsmz82smw22n6jsfg2g03a1pacakp6ys";
  };

  buildInputs = [ swc wld wayland libxkbcommon pixman fontconfig ];

  postPatch = ''
    sed -ri -e 's!\<(dmenu|dmenu_path)\>!'"$out/bin"'/&!g' dmenu_run
  '';

  preConfigure = [
    ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g; s@/usr/share/swc@${swc}/share/swc@g" config.mk''
  ];

  meta = {
      description = "A generic, highly customizable, and efficient menu for the X Window System";
      homepage = http://tools.suckless.org/dmenu;
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ ];
      platforms = with stdenv.lib.platforms; all;
  };
}
