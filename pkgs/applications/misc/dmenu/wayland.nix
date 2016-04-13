{stdenv, fetchurl #, libX11, libXinerama, enableXft, libXft, zlib
, swc, wld, wayland, libxkbcommon, pixman, fontconfig
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "dmenu-wayland-${version}";
  version = "git-2014-11-02";
  rev = "6e08b77428cc3c406ed2e90d4cae6c41df76341e";

  src = fetchurl {
    url = "https://github.com/michaelforney/dmenu/archive/${rev}.tar.gz";
    sha256 = "d0f73e442baf44a93a3b9d41a72e9cfa14f54af6049c90549f516722e3f88019";
  };

  buildInputs = [ swc wld wayland libxkbcommon pixman fontconfig ];

  postPatch = ''
    sed -ri -e 's!\<(dmenu|dmenu_path)\>!'"$out/bin"'/&!g' dmenu_run
  '';

  preConfigure = [
    ''sed -i "s@PREFIX = /usr/local@PREFIX = $out@g; s@/usr/share/swc@$(echo "$nativeBuildInputs" | grep -o '[^ ]*-swc-[^ ]*')/share/swc@g" config.mk''
  ];

  meta = {
      description = "a generic, highly customizable, and efficient menu for the X Window System";
      homepage = http://tools.suckless.org/dmenu;
      license = stdenv.lib.licenses.mit;
      maintainers = with stdenv.lib.maintainers; [ ];
      platforms = with stdenv.lib.platforms; all;
  };
}
