args : with args; 
rec {
  src = fetchmtn {
    name = "monotone-viz-mtn-checkout";
    dbs = ["monotone.ca"];
    selector = "0e9194c89eb87e62ac7d54c7b88b10b94b07fa41";
    branch = "net.venge.monotone-viz.automate";
    sha256 = "b9189ccd64c02d158517e97bce079e87843e7b1948c5c61c534aa0b885c711ac";
  } + "/";

  buildInputs = [ocaml lablgtk libgnomecanvas gtk graphviz glib 
    pkgconfig autoconf automake libtool];
  configureFlags = ["--with-lablgtk-dir=${lablgtk}/lib/ocaml/lablgtk2"];

  /* doConfigure should be specified separately */
  phaseNames = ["doAutoconf" "doConfigure" "doMakeInstall"];

  doAutoconf = fullDepEntry(''
    aclocal -I .
    autoconf -I .
  '') ["minInit" "addInputs" "doUnpack"];
      
  name = "monotone-viz-" + version;
  meta = {
    description = "Monotone commit tree visualizer";
  };
}

