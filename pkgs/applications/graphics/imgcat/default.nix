{ stdenv, fetchFromGitHub, autoconf, automake, libtool, ncurses }:

stdenv.mkDerivation rec {
  name = "imgcat-${version}";
  version = "2.3.0";

  buildInputs = [ autoconf automake libtool ncurses ];

  preConfigure = ''
    ${autoconf}/bin/autoconf
    sed -i -e "s|-ltermcap|-L ${ncurses}/lib -lncurses|" Makefile
  '';

  preInstall = ''
    makeFlagsArray=(PREFIX="$out");
  '';

  src = fetchFromGitHub {
    owner = "eddieantonio";
    repo = "imgcat";
    rev = "3d854c72f785dce0eecd9485767a7f972d54890c";
    sha256 = "0m83c33rzxvs0w214njql2c7q3fg06wnyijch3l2s88i7frl121f";
  };

  meta = with stdenv.lib; {
    description = "It's like cat, but for images";
    homepage = https://github.com/eddieantonio/imgcat;
    license = licenses.isc;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.unix;
  };
}

