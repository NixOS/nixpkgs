{stdenv, fetchurl, gmp}:
stdenv.mkDerivation rec {
  name = "ratpoints-${version}";
  version = "2.1.3";
  src = fetchurl {
    url = "http://www.mathe2.uni-bayreuth.de/stoll/programs/ratpoints-${version}.tar.gz";
    sha256 = "0zhad84sfds7izyksbqjmwpfw4rvyqk63yzdjd3ysd32zss5bgf4";
  };
  buildInputs = [gmp];
  makeFlags = "INSTALL_DIR=$(out)";
  preInstall = ''mkdir -p "$out"/{bin,share,lib,include}'';
  meta = {
    inherit version;
    description = ''A program to find rational points on hyperelliptic curves'';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://www.mathe2.uni-bayreuth.de/stoll/programs/;
    updateWalker = true;
  };
}
