{ lib, stdenv, fetchFromGitHub, yacc, ncurses, libxml2, libzip, libxls, pkg-config }:

stdenv.mkDerivation rec {
  version = "0.8.0";
  pname = "sc-im";

  src = fetchFromGitHub {
    owner = "andmarti1424";
    repo = "sc-im";
    rev = "v${version}";
    sha256 = "sha256-/eG2BdkyfEGoSzPu6jT+Bn1RZTGT1D3etGj1tYchm1M=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ yacc ncurses libxml2 libzip libxls ];

  buildPhase = ''
    cd src

    sed 's/LDLIBS += -lm/& -lncurses/' -i Makefile

    sed -e "\|^prefix  = /usr/local|   s|/usr/local|$out|" \
        -e "\|^#LDLIBS += -lxlsreader| s|^#||            " \
        -e "\|^#CFLAGS += -DXLS|       s|^#||            " \
        -i Makefile

    make
    export DESTDIR=$out
  '';

  installPhase = ''
    make install prefix=
  '';

  meta = with lib; {
    homepage = "https://github.com/andmarti1424/sc-im";
    description = "SC-IM - Spreadsheet Calculator Improvised - SC fork";
    license = licenses.bsdOriginal;
    maintainers = [ ];
    platforms = platforms.unix;
  };

}
