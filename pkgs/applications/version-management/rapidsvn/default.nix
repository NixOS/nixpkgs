{stdenv, fetchurl, wxGTK, subversion, apr, aprutil, python}:

stdenv.mkDerivation {
  name = "rapidsvn-0.12";

  src = fetchurl {
    url = http://www.rapidsvn.org/download/release/0.12/rapidsvn-0.12.0-1.tar.gz;
    sha256 = "1i3afjmx99ljw1bj54q47fs0g1q9dmxxvr4ciq7ncp5s52shszgg";
  };

  buildInputs = [ wxGTK subversion apr aprutil python ];

  configureFlags = [ "--with-svn-include=${subversion}/include" 
    "--with-svn-lib=${subversion}/lib" ];

  meta = {
    description = "Multi-platform GUI front-end for the Subversion revision system";
    homepage = http://rapidsvn.tigris.org/;
    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.viric ];
  };
}
