{ pkgs, fetchurl, stdenv, ncurses, utillinux, file, libX11 }:

let
  name = "vifm-${version}";
  version = "0.7.6";

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url="mirror://sourceforge/project/vifm/vifm/${name}.tar.bz2";
    sha256 ="03v50hmgfvrci5fz31zmklmp6ix7qpqnhvm6639wbk3g5mcrh5w6";
  };

  #phaseNames = ["doConfigure" "doMakeInstall"];
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

