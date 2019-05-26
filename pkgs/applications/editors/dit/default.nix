{ lib, fetchurl, stdenv, libiconv, ncurses, lua }:

stdenv.mkDerivation rec {
  name = "dit-${version}";
  version = "0.5";

  src = fetchurl {
    url = "https://hisham.hm/dit/releases/${version}/${name}.tar.gz";
    sha256 = "05vhr1gl3bb5fg49v84xhmjaqdjw6djampvylw10ydvbpnpvjvjc";
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
    homepage = https://hisham.hm/dit/;
    license = licenses.gpl2;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ davidak ];
  };
}
