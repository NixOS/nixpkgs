args : with args; 

if ! bazaar.python.readlineSupport then 
  throw "Bazaar Tools require readline support in python."
else

rec {
  src = fetchurl {
    url = http://launchpad.net/bzrtools/stable/1.5.0/+download/bzrtools-1.5.0.tar.gz;
    sha256 = "0lm4qhsjy3k8zp9hcahlf37v69w6lhhz2x3hjskgm3rk6b0bngjz";
  };

  buildInputs = [];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = [(simplyShare "bzrtools")];
      
  name = "bzr-tools-1.5";
  meta = {
    description = "Bazaar plugins.";
  };
}
