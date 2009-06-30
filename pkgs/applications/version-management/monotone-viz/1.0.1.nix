args : with args; 
rec {
  src = fetchurl {
    name = "monotone-viz-1.0.1-nolablgtk.tar.gz";
    urls = [
      http://ftp.debian.org/debian/pool/main/m/monotone-viz/monotone-viz_1.0.1.orig.tar.gz
      #http://oandrieu.nerim.net/monotone-viz/monotone-viz-1.0.1-nolablgtk.tar.gz
    ];
    sha256 = "066qwrknjk5hwk9jblnf0bzvbmfbabq0zhsxkd3nzk469zkpvhl2";
  };

  buildInputs = [ocaml lablgtk libgnomecanvas gtk graphviz glib pkgconfig];
  configureFlags = ["--with-lablgtk-dir=${lablgtk}/lib/ocaml/lablgtk2"];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doMakeInstall"];
      
  name = "monotone-viz-" + version;
  meta = {
    description = "Monotone commit tree visualizer";
  };
}

