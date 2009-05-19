args : with args; 
let version = lib.getAttr ["version"] "1.1.0" args; in
rec {
  src = fetchurl {
    url = http://downloads.sourceforge.net/ofset/drgeo-1.1.0.tar.gz;
    sha256 = "05i2czgzhpzi80xxghinvkyqx4ym0gm9f38fz53idjhigiivp4wc";
  };

  buildInputs = [libglade gtk guile libxml2
    perl intltool libtool pkgconfig];
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doConfigure" "doPreBuild" "doMakeInstall"];

  doPreBuild = fullDepEntry (''
    cp drgeo.desktop.in drgeo.desktop
  '') ["minInit" "doUnpack"];
      
  name = "drgeo-" + version;
  meta = {
    description = "Interactive geometry program";
  };
}
