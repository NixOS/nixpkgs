a@{fetchsvn, libxml2, gtk, curl, pkgconfig, lib, ...} :  
let 
  fetchsvn = a.fetchsvn;

  buildInputs = with a; [
    libxml2 gtk curl pkgconfig
  ];
in
rec {
  src = fetchsvn {
    url = http://svn.openstreetmap.org/applications/rendering/gosmore;
    sha256 = "0ds61gl75rnzvm0hj9papl5sfcgdv4310df9ch7x9rifssfli9zm";
    rev = "24178";
  } + "/";

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["fixCurlIncludes" "doConfigure" "doMakeInstall"];

  fixCurlIncludes = a.fullDepEntry ''
    sed -e '/curl.types.h/d' -i *.{c,h,hpp,cpp}
  '' ["minInit" "doUnpack"];
      
  name = "gosmore-r21657";
  meta = {
    description = "Open Street Map viewer";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = a.lib.platforms.linux;
  };
}
