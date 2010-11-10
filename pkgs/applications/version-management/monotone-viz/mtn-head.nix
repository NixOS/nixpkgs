args : with args; 
rec {
  srcDrv = fetchmtn {
    name = "monotone-viz-mtn-checkout";
    dbs = ["monotone.mtn-host.prjek.net"];
    selector = "c3fdb3af1c7c89989c7da8062bb62203f2aaccf0";
    branch = "net.venge.monotone-viz.new-stdio";
    sha256 = "661c6a49d442b7e5a7ba455bb9a892e7e12b3968c2ddd69375e7bd0cd0b3ecb9";
  };
  src = srcDrv + "/";

  buildInputs = [ocaml lablgtk libgnomecanvas gtk graphviz glib 
    pkgconfig autoconf automake libtool];
  configureFlags = ["--with-lablgtk-dir=${lablgtk}/lib/ocaml/lablgtk2"];

  /* doConfigure should be specified separately */
  phaseNames = ["doAutoconf" "doPatch" "doConfigure" "doMakeInstall"];

  doAutoconf = fullDepEntry(''
    aclocal -I .
    autoconf -I .
  '') ["minInit" "addInputs" "doUnpack"];

  name = "monotone-viz-mtn-head";
  meta = {
    description = "Monotone commit tree visualizer";
    maintainers = [args.lib.maintainers.raskin];
  };
  passthru = {
    inherit srcDrv;
  };
}

