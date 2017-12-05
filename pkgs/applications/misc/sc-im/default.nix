{ stdenv, fetchFromGitHub, yacc, ncurses, libxml2, libzip, libxls, pkgconfig }:

stdenv.mkDerivation rec {
  version = "0.6.0";
  name = "sc-im-${version}";

  src = fetchFromGitHub {
    owner = "andmarti1424";
    repo = "sc-im";
    rev = "v${version}";
    sha256 = "02ak3b0vv72mv38cwvy7qp0y6hgrzcgahkv1apgks3drpnz5w1sj";
  };

  buildInputs = [ yacc ncurses libxml2 libzip libxls pkgconfig ];

  buildPhase = ''
    cd src

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

  meta = with stdenv.lib; {
    homepage = https://github.com/andmarti1424/sc-im;
    description = "SC-IM - Spreadsheet Calculator Improvised - SC fork";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.matthiasbeyer ];
    platforms = platforms.linux; # Cannot test others
  };

}
