{ lib, stdenv, fetchurl, glib, gtk2, pkg-config, popt }:

let
  version = "0.9.2";
in

stdenv.mkDerivation rec {
  pname = "gmrun";
  inherit version;

  src = fetchurl {
    url = "mirror://sourceforge/gmrun/${pname}-${version}.tar.gz";
    sha256 = "180z6hbax1qypy5cyy2z6nn7fzxla4ib47ck8mqwr714ag77na8p";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ glib gtk2 popt ];

  doCheck = true;

  enableParallelBuilding = true;

  patches = [
      ./gcc43.patch
      ./find-config-file-in-system-etc-dir.patch
      ./gmrun-0.9.2-xdg.patch
    ];

  meta = with lib; {
    description = "Gnome Completion-Run Utility";
    longDescription = ''
      A simple program which provides a "run program" window, featuring a bash-like TAB completion.
      It uses GTK interface.
      Also, supports CTRL-R / CTRL-S / "!" for searching through history.
      Running commands in a terminal with CTRL-Enter. URL handlers.
    '';
    homepage = "https://sourceforge.net/projects/gmrun/";
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = platforms.all;
    mainProgram = "gmrun";
  };
}
