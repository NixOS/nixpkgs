{ pkgs, fetchurl, stdenv, ncurses, utillinux, file, libX11, which, groff }:

let
  name = "vifm-${version}";
  version = "0.7.8";

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/project/vifm/vifm/${name}.tar.bz2";
    sha256 = "00vnkr60ci6qwh95kzx399xm97g26svxl9i0y77qv99q41nb5ysx";
  };

  buildInputs = [ utillinux ncurses file libX11 which groff ];

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

