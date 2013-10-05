args : with args; 

rec {
  version = "2.2.0";
  src = fetchurl {
    url = "http://launchpad.net/bzrtools/stable/${version}/+download/bzrtools-${version}.tar.gz";
    sha256 = "835e0dc2b3b798d3c88b960bf719fe3b4cec7ae241908aafeb6aafe4c83f591b";
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
