{ stdenv, fetchurl, python, rcs, git }:

stdenv.mkDerivation rec {
  name = "src-0.12";

  src = fetchurl {
    url = "http://www.catb.org/~esr/src/${name}.tar.gz";
    sha256 = "1w8k9z2dxim99nniid9kjsc5lzri7m4sd0n819y73aqcdi54lr1s";
  };

  buildInputs = [ python ];

  patches = [ ./path.patch ];

  postPatch = ''
    sed -i \
      -e 's|@python@|${python}|' \
      -e 's|@rcs@|${rcs}|' \
      -e 's|@git@|${git}|' \
      src srctest
  '';

  makeFlags = [ "prefix=$(out)" ];

  doCheck = true;

  meta = {
    description = "Simple single-file revision control";

    homepage = http://www.catb.org/~esr/src/;

    license = [ stdenv.lib.licenses.bsd3 ];

    maintainers = [ stdenv.lib.maintainers.shlevy ];

    platforms = stdenv.lib.platforms.all;
  };
}
