{stdenv, fetchurl, readline, perl, libX11, libpng, libXt, zlib}:

stdenv.mkDerivation {
  name = "emboss-5.0.0-9";
  src = fetchurl {
    url = ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-5.0.0.tar.gz;
    sha256 = "1bj0bxfj97cgnk3w3123cqn5sq5xsbvzs8bzvqkgy6d7hadz1rk4";
  };
  patch = fetchurl {
    url = ftp://emboss.open-bio.org/pub/EMBOSS/fixes/patches/patch-1-9.gz;
    sha256 = "1pfn5zdxrr71c3kwpdkzmmsqvdwkmynkvcr707vqh73h9cjhk3c1";
  };

  buildInputs = [readline perl libpng libX11 libXt zlib];

  preConfigure = ''
    gzip -d $patch | patch -p1
  '';

  meta = {
    description     = "EMBOSS is 'The European Molecular Biology Open Software Suite'";
    longDescription = ''EMBOSS is a free Open Source software analysis package
    specially developed for the needs of the molecular biology (e.g. EMBnet)
    user community. The software automatically copes with data in a variety of
    formats and even allows transparent retrieval of sequence data from the
    web.'';
    license     = "GPL2";
    homepage    = http://emboss.sourceforge.net/;
  };
}
