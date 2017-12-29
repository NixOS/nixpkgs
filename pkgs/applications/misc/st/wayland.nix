{ stdenv, fetchurl, pkgconfig, writeText
, ncurses, wayland, wld, libxkbcommon, fontconfig, pixman
, conf ? null, patches ? [] }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st-wayland-${version}";
  version = "git-2015-08-29";
  rev = "61b47b76a09599c8093214e28c48938f5b424daa";

  src = fetchurl {
    url = "https://github.com/michaelforney/st/archive/${rev}.tar.gz";
    sha256 = "7164da135f02405dba5ae3131dfd896e072df29ac6c0928f3b887beffb8a7d97";
  };

  inherit patches;

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";

  buildInputs = [ pkgconfig ncurses wayland wld libxkbcommon fontconfig pixman ];

  NIX_LDFLAGS = "-lfontconfig";

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';

  meta = {
    homepage = http://st.suckless.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = with platforms; linux;
  };
}
