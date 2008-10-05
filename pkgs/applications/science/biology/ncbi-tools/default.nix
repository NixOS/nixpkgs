{stdenv, fetchurl, cpio}:

# Note: may need the C-libs at ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools++/2008/Mar_17_2008/NCBI_C_Toolkit/ncbi_c--Mar_17_2008.tar.gz (or split out?)

stdenv.mkDerivation rec {
  name = "ncbi_cxx";
  ncbi_version = "Mar_17_2008";
  src = fetchurl {
    url = "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools++/2008/${ncbi_version}/ncbi_cxx--${ncbi_version}.tar.gz";
    sha256 = "0mxbmz6gndallz8l5jdslq6illa3hgf31xi2yb984mqm9in485as";
  };

  configureFlags = "--without-debug --with-bin-release --with-dll --without-static";
  buildInputs = [cpio];

  meta = {
    description = ''NCBI Bioinformatics toolbox (incl. blast)'';
    longDescription = ''The NCBI Bioinformatics toolsbox, including command-line utilties, libraries and include files. No X11 support (at this point).'';
    homepage = http://www.ncbi.nlm.nih.gov/IEB/ToolBox/; 
    license = "GPL";
    priority = "5";   # zlib.so gives a conflict with zlib
  };
}
