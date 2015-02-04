{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "termite-terminfo-${version}";
  version = "9";

  src = fetchurl {
    url = "https://github.com/thestinger/termite/archive/v${version}.tar.gz";
    sha256 = "1gfwyfivmf50qba2x5vk3lq7ws2cbg1cv1ppbvc9p4nr4fw8al9j";
  };

  buildInputs = [ ncurses ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/terminfo
    tic -x termite.terminfo -o $out/share/terminfo
  '';

  meta = with stdenv.lib; {
    description = "Just the terminfo for termite (A Simple VTE-based terminal)";
    license = licenses.lgpl2Plus;
    homepage = https://github.com/thestinger/termite/;
    maintainers = [ maintainers.koral ];
    platforms = platforms.all;
  };
}
