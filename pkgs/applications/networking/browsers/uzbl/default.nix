a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "2009.06.06" a; 
  buildInputs = with a; [
    pkgconfig webkit libsoup gtk 
  ];
in
rec {
  src = fetchurl {
    url = "http://github.com/Dieterbe/uzbl/tarball/${version}";
    sha256 = "1bgajpcsv0a8nmliqkrk99d3k5s60acjgvh0sx7znsnjajbfv3yz";
    name = "uzbl-master-${version}.tar.gz";
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doMakeInstall"];

  installFlags = "PREFIX=$out";
      
  name = "uzbl-" + version;
  meta = {
    description = "Tiny externally controllable webkit browser";
  };
}
