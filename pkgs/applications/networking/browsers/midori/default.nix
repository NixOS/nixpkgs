args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  doPatchShebangs = args.doPatchShebangs;
  makeManyWrappers = args.makeManyWrappers;

  version = lib.attrByPath ["version"] "0.1.7" args; 
  buildInputs = with args; [
    intltool python imagemagick gtk glib webkit libxml2 
    gtksourceview pkgconfig which gettext makeWrapper 
    file libidn sqlite docutils libnotify libsoup
  ];
in
rec {
  src = fetchurl {
    url = "http://goodies.xfce.org/releases/midori/midori-${version}.tar.bz2";
    sha256 = if version == "0.1.7" then 
      "1bxs4nlwvhzwiq73lf1gvx7qqdm1hm4x1hym1b0q0dhwhdvafx4v"
    else null;
  };

  inherit buildInputs;
  configureFlags = [];

  /* doConfigure should be specified separately */
  phaseNames = ["doUnpack" "shebangsHere" "doConfigure" 
    "doMakeInstall" "shebangsInstalled" "wrapWK"
    ];
      
  shebangsHere = (doPatchShebangs ".");
  shebangsInstalled = (doPatchShebangs "$out/bin");
  wrapWK = (makeManyWrappers "$out/bin/*" "--set WEBKIT_IGNORE_SSL_ERRORS 1");

  name = "midori-" + version;
  meta = {
    description = "Light WebKit-based web browser with GTK GUI.";
    maintainers = [args.lib.maintainers.raskin];
    platforms = with args.lib.platforms;
      linux;
  };
}
