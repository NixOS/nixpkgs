{stdenv, fetchurl, python, jre, python27Packages }:

stdenv.mkDerivation rec {
  version = "38.69";
  name = "bbtools-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/bbmap/BBMap_${version}.tar.gz";
    sha256 = "00gzilb82rhgmwagcqp84d2kqqzm5lc15952xifzm82vszw4zkbj";
  };
  propagatedBuildInputs = with python27Packages; [ python jre matplotlib ]; # missing mpld3

  builder = ./builder.sh;

  meta = with stdenv.lib; {
    description     = "Various bioinformatic tools including BBMap a short-read mapper";
    longDescription = ''
      BBTools is a series of Java programs, which includes BBMap a short-read mapper for DNA and RNA-seq data.
    '';
    license   = licenses.bsd3;
    homepage  = "https://jgi.doe.gov/data-and-tools/bbtools/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ unode ];
  };
}
