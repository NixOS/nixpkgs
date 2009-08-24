a :  
let 
  fetchurl = a.fetchurl;
  s = import ./src-info-for-default.nix;

  version = a.lib.attrByPath ["version"] s.version a; 
  buildInputs = with a; [
    
  ];
in
rec {
  src = fetchurl {
    url = s.url;
    sha256 = s.hash;
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "${abort "Specify name"}-" + version;
  meta = {
    description = "${abort "Specify description"}";
    maintainers = [
      a.lib.maintainers.(abort "Specify maintainer")
    ];
  };
}
