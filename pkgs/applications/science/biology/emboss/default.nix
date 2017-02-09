{stdenv, fetchurl, readline, perl, libX11, libpng, libXt, zlib}:

stdenv.mkDerivation {
  name = "emboss-6.6.0";
  src = fetchurl {
    url = "ftp://emboss.open-bio.org/pub/EMBOSS/EMBOSS-6.6.0.tar.gz";
    sha256 = "7184a763d39ad96bb598bfd531628a34aa53e474db9e7cac4416c2a40ab10c6e";
  };
  # patch = fetchurl {
  #   url = ftp://emboss.open-bio.org/pub/EMBOSS/fixes/patches/patch-1-9.gz;
  #   sha256 = "1pfn5zdxrr71c3kwpdkzmmsqvdwkmynkvcr707vqh73h9cjhk3c1";
  # };

  buildInputs = [readline perl libpng libX11 libXt zlib];

  # preConfigure = ''
  #   gzip -d $patch | patch -p1
  # '';

  meta = {
    description     = "The European Molecular Biology Open Software Suite";
    longDescription = ''EMBOSS is a free Open Source software analysis package
    specially developed for the needs of the molecular biology (e.g. EMBnet)
    user community, including libraries. The software automatically copes with
    data in a variety of formats and even allows transparent retrieval of
    sequence data from the web.''; 
    license     = "GPL2";
    homepage    = http://emboss.sourceforge.net/;
  };
}
