{stdenv, fetchurl, cpio}:

# The NCBI package only builds on 32bits - on 64bits it breaks because
# of position dependent code. Debian packagers have written replacement
# make files(!). Either we use these, or negotiate a version which can
# be pushed upstream to NCBI.
#
# Another note: you may want the older and deprecated C-libs at ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools++/2008/Mar_17_2008/NCBI_C_Toolkit/ncbi_c--Mar_17_2008.tar.gz

stdenv.mkDerivation rec {
  name = "ncbi_tools";
  ncbi_version = "Dec_31_2008";
  src = fetchurl {
    url = "ftp://ftp.ncbi.nih.gov/toolbox/ncbi_tools++/2008/${ncbi_version}/ncbi_cxx--${ncbi_version}.tar.gz";
    sha256 = "1b2v0dcdqn3bysgdkj57sxmd6s0hc9wpnxssviz399g6plhxggbr";
  };

  configureFlags = "--without-debug --with-bin-release --with-dll --without-static";
  buildInputs = [ cpio ];

  meta = {
    description = ''NCBI Bioinformatics toolbox (incl. BLAST)'';
    longDescription = ''The NCBI Bioinformatics toolsbox, including command-line utilties, libraries and include files. No X11 support'';
    homepage = http://www.ncbi.nlm.nih.gov/IEB/ToolBox/; 
    license = "GPL";
    priority = 5;   # zlib.so gives a conflict with zlib
    broken = true;
  };
}
