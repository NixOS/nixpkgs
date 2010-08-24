args :  
let 
  lib = args.lib;
  fetchurl = args.fetchurl;
  doPatchShebangs = args.doPatchShebangs;
  makeManyWrappers = args.makeManyWrappers;

  version = "0.2"; 
  release = "7";
  buildInputs = with args; [
    intltool python imagemagick gtk glib webkit libxml2 
    gtksourceview pkgconfig which gettext makeWrapper 
    file libidn sqlite docutils libnotify libsoup vala
    kbproto xproto scrnsaverproto libXScrnSaver dbus_glib
  ];
in
rec {
  src = fetchurl {
    url = "http://archive.xfce.org/src/apps/midori/${version}/midori-${version}.${release}.tar.bz2";
    sha256 = "b1dcc479ceb938c8d9cdea098c8d72d563bce5010c27fbcaa4c992d10f2d809c";
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

  name = "midori-${version}.${release}";
  meta = {
    description = "Light WebKit-based web browser with GTK GUI.";
    maintainers = [args.lib.maintainers.raskin];
    platforms = with args.lib.platforms;
      linux;
  };
}
