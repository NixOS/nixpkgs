{ lib, stdenv, fetchurl, fetchpatch, libmikmod, ncurses }:

stdenv.mkDerivation rec {
  pname = "mikmod";
  version = "3.2.8";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1k54p8pn3jinha0f2i23ad15pf1pamibzcxjrbzjbklpcz1ipc6v";
  };

  patches = [
    # Fix player startup crash due to stack overflow check:
    #   https://sourceforge.net/p/mikmod/patches/17/
    (fetchpatch {
      name = "fortify-source-3.patch";
      url = "https://sourceforge.net/p/mikmod/patches/17/attachment/0001-mikmod-fix-startup-crash-on-_FROTIFY_SOURCE-3-system.patch";
      stripLen = 1;
      hash = "sha256-YtbnLTsW3oYPo4r3fh3DUd3DD5ogWrCNlrDcneY03U0=";
    })
  ];

  buildInputs = [ libmikmod ncurses ];

  meta = {
    description = "Tracker music player for the terminal";
    homepage = "http://mikmod.shlomifish.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = with lib.platforms; linux;
  };
}
