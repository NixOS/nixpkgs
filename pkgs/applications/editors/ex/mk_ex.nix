{ pkgs, fetchurl, stdenv, version, release, hash, desc }:

stdenv.mkDerivation rec {
  name = "ex-${version}";

  src = fetchurl {
    url = "https://github.com/n-t-roff/${name}/archive/${release}.tar.gz";
    sha256 = hash;
  };

  buildInputs = with pkgs; [ ncurses ];

  configurePhase = ''
    sed -i 's/^PREFIX.*//' Makefile.in
    sh ./configure
  '';

  buildPhase = ''
    PREFIX=$out make
  '';

  installPhase = ''
    PREFIX=$out make install
  '';

  meta = {
    description = desc;
    license = stdenv.lib.licenses.gpl3Plus;
    homepage = "https://github.com/n-t-roff/${name}";
    maintainers = [ stdenv.lib.maintainers.matthiasbeyer ];
    platforms = stdenv.lib.platforms.unix;
  };
}
