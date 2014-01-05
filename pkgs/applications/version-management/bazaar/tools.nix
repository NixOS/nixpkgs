args : with args; 

rec {
  version = "2.5";
  src = fetchurl {
    url = "http://launchpad.net/bzrtools/stable/${version}/+download/bzrtools-${version}.tar.gz";
    sha256 = "0gzh63vl9006cpklszwmsymrq5ddxxrnxwbv5bwi740jlvxzdkxw";
  };

  buildInputs = [];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = [(simplyShare "bzrtools")];
      
  name = "bzr-tools-${version}";
  meta = {
    description = "Bazaar plugins";
  };
}
