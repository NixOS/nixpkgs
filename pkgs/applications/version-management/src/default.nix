{ stdenv, fetchurl, python, rcs, git }:

stdenv.mkDerivation rec {
  name = "src-0.13";

  src = fetchurl {
    url = "http://www.catb.org/~esr/src/${name}.tar.gz";
    sha256 = "03x0slgi6bnzgfn7f9qbl6jma0pj7357kwdh832l3v8zafk41p51";
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
