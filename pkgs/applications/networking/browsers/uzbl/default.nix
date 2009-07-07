a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "2009.07.03" a; 
  buildInputs = with a; [
    pkgconfig webkit libsoup gtk 
  ];
in
rec {
  src = fetchurl {
    url = "http://github.com/Dieterbe/uzbl/tarball/${version}";
    sha256 = "18lsrylkgicqrlw03978v71cycyyba1d4lbiszw7dk89hd4ziqv2";
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
