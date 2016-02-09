{ stdenv, fetchurl
, slang, ncurses, openssl }:

let version = "1.0.2"; in

stdenv.mkDerivation {
  name = "slrn-${version}";

  src = fetchurl {
    url = "http://www.jedsoft.org/releases/slrn/slrn-${version}.tar.gz";
    sha256 = "1gn6m2zha2nnnrh9lz3m3nrqk6fgfij1wc53pg25j7sdgvlziv12";
  };

  preConfigure = ''
    sed -i -e "s|-ltermcap|-lncurses|" configure
    sed -i autoconf/Makefile.in src/Makefile.in \
      -e "s|/bin/cp|cp|"  \
      -e "s|/bin/rm|rm|"
  '';

  configureFlags = "--with-slang=${slang} --with-ssl=${openssl}";

  buildInputs = [ slang ncurses openssl ];

  meta = with stdenv.lib; {
    description = "The slrn (S-Lang read news) newsreader";
    homepage = http://slrn.sourceforge.net/index.html;
    maintainers = with maintainers; [ ehmry ];
    license = licenses.gpl2;
  };
}
