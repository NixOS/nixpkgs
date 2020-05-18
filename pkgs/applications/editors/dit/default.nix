{ lib, fetchurl, stdenv, libiconv, ncurses, lua }:

stdenv.mkDerivation rec {
  pname = "dit";
  version = "0.6";

  src = fetchurl {
    url = "https://hisham.hm/dit/releases/${version}/${pname}-${version}.tar.gz";
    sha256 = "0ryvm54xxkg2gcgz4r8zdxrl6j2h8mgg9nfqmdmdr31qkcj8wjsq";
  };

  buildInputs = [ ncurses lua ]
    ++ lib.optional stdenv.isDarwin libiconv;

  # fix paths
  prePatch = ''
    patchShebangs tools/GenHeaders
    substituteInPlace Prototypes.h --replace 'tail' "$(type -P tail)"
  '';

  meta = with stdenv.lib; {
    description = "A console text editor for Unix that you already know how to use";
    homepage = "https://hisham.hm/dit/";
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ davidak ];
  };
}
