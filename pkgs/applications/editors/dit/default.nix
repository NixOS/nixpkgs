{ fetchurl, stdenv, coreutils, ncurses, lua }:

stdenv.mkDerivation rec {
  name = "dit-${version}";
  version = "0.4";

  src = fetchurl {
    url = "https://hisham.hm/dit/releases/${version}/${name}.tar.gz";
    sha256 = "0bwczbv7annbbpg7bgbsqd5kwypn81sza4v7v99fin94wwmcn784";
  };

  buildInputs = [ coreutils ncurses lua ];

  prePatch = ''
    patchShebangs tools/GenHeaders
  '';

  # needs GNU tail for tail -r
  postPatch = ''
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
