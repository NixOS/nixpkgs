args : with args; 
rec {
  src = fetchurl {
    url = http://darcs.arstecnica.it/tailor-0.9.31.tar.gz;
    sha256 = "1apzd6mfmhgmxffzgzwsr17gnyqj6bycn783l9105cihsfcv9v3j";
  };

  buildInputs = [python makeWrapper];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["installPythonPackage" "wrapBinContentsPython"];
      
  name = "tailor-" + version;
  meta = {
    description = "Version control tools integration tool";
  };
}
 
