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
    sha256 = "0r6c6gk0pjljwcqxjy18d2s526pyv2kwydf5gl9k68s1b20ps3nd";
    rev = "21657";
  } + "/";

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be removed if not needed */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "gosmore-r21657";
  meta = {
    description = "Open Street Map viewer";
    maintainers = [
      a.lib.maintainers.raskin
    ];
    platforms = a.lib.platforms.linux;
  };
}
