{ pkgs, fetchurl, stdenv, ncurses, utillinux, file, libX11, which, groff }:

let
  name = "vifm-${version}";
  version = "0.8.1";

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "mirror://sourceforge/project/vifm/vifm/${name}.tar.bz2";
    sha256 = "0yf3xc4czdrcbvmhq7d4xkck5phrmxwybmnv1zdb56qg56baq64r";
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

