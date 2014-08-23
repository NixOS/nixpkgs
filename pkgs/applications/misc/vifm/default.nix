{ pkgs, fetchurl, stdenv, ncurses, utillinux, file, libX11 }:

let
  name = "vifm-${version}";
  version = "0.7.7";

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/project/vifm/vifm/${name}.tar.bz2";
    sha256 = "1lflmkd5q7qqi9d44py0y41pcx5bsadkihn3gc0x5cka04f2gh0d";
  };

  buildInputs = [ utillinux ncurses file libX11 ];

  meta = {
    description = "A vi-like file manager";
    maintainers = with pkgs.lib.maintainers; [ raskin garbas ];
    platforms = pkgs.lib.platforms.linux;
    license = pkgs.lib.licenses.gpl2;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://vifm.sf.net";
    };
  };
}

