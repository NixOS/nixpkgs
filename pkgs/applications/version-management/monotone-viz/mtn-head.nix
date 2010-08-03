args : with args; 
rec {
  src = fetchmtn {
    name = "monotone-viz-mtn-checkout";
    dbs = ["monotone.ca"];
    selector = "b34ff2e695b53c2d73d533a3ffa7cb081b48eefb";
    branch = "net.venge.monotone-viz.new-stdio";
    sha256 = "06263564bc111d865b50b4a9587a86f8d97fff47625a3c1cb98d90b79faf7889";
  } + "/";

  buildInputs = [ocaml lablgtk libgnomecanvas gtk graphviz glib 
    pkgconfig autoconf automake libtool];
  configureFlags = ["--with-lablgtk-dir=${lablgtk}/lib/ocaml/lablgtk2"];

  /* doConfigure should be specified separately */
  phaseNames = ["doAutoconf" "doPatch" "doConfigure" "doMakeInstall"];

  doAutoconf = fullDepEntry(''
    aclocal -I .
    autoconf -I .
  '') ["minInit" "addInputs" "doUnpack"];

  patches = [ ./graphviz.patch ];
      
  name = "monotone-viz-mtn-head";
  meta = {
    description = "Monotone commit tree visualizer";
    maintainers = [args.lib.maintainers.raskin];
  };
}

