args : with args; 
rec {
  src = fetchurl {
    url = http://oandrieu.nerim.net/monotone-viz/monotone-viz-1.0.1-nolablgtk.tar.gz;
    sha256 = "0aqz65mlqplj5ccr8czcr6hvliclf9y1xi1rrs2z2s3fvahasxnp";
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

