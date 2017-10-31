{ stdenv, lib, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "heme-${version}";
  version = "0.4.2";
  src = fetchurl {
    url = "mirror://sourceforge/project/heme/heme/heme-${version}/heme-${version}.tar.gz";
    sha256 = "0wsrnj5mrlazgqs4252k30aw8m86qw0z9dmrsli9zdxl7j4cg99v";
  };
  postPatch = ''
    substituteInPlace Makefile \
      --replace "/usr/local" "$out" \
      --replace "CFLAGS = " "CFLAGS = -I${ncurses.dev}/include " \
      --replace "LDFLAGS = " "LDFLAGS = -L${ncurses.out}/lib " \
      --replace "-lcurses" "-lncurses"
  '';
  buildInputs = [ ncurses ];
  preBuild = ''
    mkdir -p $out/bin
    mkdir -p $out/man/man1
  '';
  meta = with lib; {
    description = "Portable and fast console hex editor for unix operating systems";
    homepage = http://heme.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cstrahan ];
  };
}
