{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "bviplus-${version}";
  version = "0.9.4";
  src = fetchurl {
    url = "mirror://sourceforge/project/bviplus/bviplus/${version}/bviplus-${version}.tgz";
    sha256 = "10x6fbn8v6i0y0m40ja30pwpyqksnn8k2vqd290vxxlvlhzah4zb";
  };
  buildInputs = [
    ncurses
  ];

  postPatch = ''
      # Patch taken from https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=bviplus
      sed -i -r 's,inline (void compute_percent_complete),\1,' vf_backend.c
  '';

  makeFlags = "PREFIX=$(out)";
  meta = with lib; {
    description = "ncurses based hex editor with a vim-like interface";
    homepage = "http://bviplus.sourceforge.net";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
