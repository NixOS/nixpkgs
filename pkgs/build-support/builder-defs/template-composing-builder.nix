a :  
let 
  fetchurl = a.fetchurl;

  version = a.lib.attrByPath ["version"] "" a; 
  buildInputs = with a; [
    
  ];
in
rec {
  src = /* Here a fetchurl expression goes */;

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
