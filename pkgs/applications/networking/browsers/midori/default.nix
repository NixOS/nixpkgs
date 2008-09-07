args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  doPatchShebangs = args.doPatchShebangs;
  makeManyWrappers = args.makeManyWrappers;

  version = lib.getAttr ["version"] "0.0.21" args; 
  buildInputs = with args; [
    intltool python imagemagick gtk glib webkit libxml2 
    gtksourceview pkgconfig which gettext makeWrapper 
  ];
in
rec {
  src = fetchurl {
    url = "http://goodies.xfce.org/releases/midori/midori-${version}.tar.bz2";
    sha256 = if version == "0.0.21" then 
      "0cbpvjdfzgbqwn8rfkp3l35scfvz9cc8hip8v35vkxpac9igcqg5"
    else null;
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doUnpack" (doPatchShebangs ".") "doConfigure" 
    "doMakeInstall" (doPatchShebangs "$out/bin") 
    (makeManyWrappers "$out/bin/*" "--set WEBKIT_IGNORE_SSL_ERRORS 1")];
      
  name = "midori-" + version;
  meta = {
    description = "Light WebKit-based web browser with GTK GUI.";
  };
}
